require 'spec_helper'

RSpec.describe 'AkerPermissionClientConfig' do
  context 'a client using this config' do
    before do
      class MyClient
        include AkerPermissionClientConfig
      end
    end
    context 'when authorizing a user' do
      before do
        @user = 'test@test'
        @role = :execute
      end
      context 'evaluating to use a resource' do
        before do
          @resource = double('resource', id: '1234')
          result = double('result')
          @response = MyClient.new
          allow(@response).to receive(:id).and_return('1234')
          allow(MyClient).to receive(:where).and_return(result)
          allow(result).to receive(:includes).and_return([@response])
        end
        it 'returns true if the user has the specified permission' do
          @permissions = [double('Permission', permitted: @user, permission_type: :execute)]
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource, @user)}.to_not raise_error
        end
        it 'returns true if one of the permissions is as required' do
          @permissions = [
            double('Permission', permitted: 'user2', permission_type: :read),
            double('Permission', permitted: 'user3', permission_type: :read),
            double('Permission', permitted: @user, permission_type: :execute)
          ]
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource, @user)}.to_not raise_error
        end
        it 'raises an exception if it does not have the correct permission' do
          @permissions = [double('Permission', permitted: @user, permission_type: :read)]
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource, @user)}.to raise_error(AkerPermissionGem::NotAuthorized)
        end
        it 'raises an exception if it does not have any permission' do
          @permissions = [double('Permission', permitted: 'otheruser', permission_type: :execute)]
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource, @user)}.to raise_error(AkerPermissionGem::NotAuthorized)
        end
        it 'raises an exception if there is no permission specified' do
          @permissions = []
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource, @user)}.to raise_error(AkerPermissionGem::NotAuthorized)
        end
        it 'performs validation while using resource id instead of resource' do
          @permissions = [double('Permission', permitted: @user, permission_type: :execute)]
          allow(@response).to receive(:permissions).and_return(@permissions)
          expect{MyClient.authorize!(@role, @resource.id, @user)}.to_not raise_error
        end
      end
    end
  end
end