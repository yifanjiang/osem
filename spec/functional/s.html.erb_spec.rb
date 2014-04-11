require 'spec_helper'

describe '/accounts/sign_in' do
  fixtures :users
  fixtures :roles
  it 'displays error for wrong account details' do
    visit '/accounts/sign_in'
    fill_in 'Email', with: "Example@example.com"
    fill_in 'Password', with: "User123"
    click_button 'Sign in'
    page.should have_content 'Invalid email or password.'
  end
  
  it 'performs correct sign in' do
    visit '/accounts/sign_in'
    
    users(:one)
    fill_in 'Email', with: "test1@gmail.com"
    fill_in 'Password', with: "stella"
    click_button 'Sign in'
#     expect(response.status).to eq(301)
    expect(response).to render_template("index")
    page.should have_content 'successful'
  end
end