     
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'models/user'
require 'pry' if development?
enable :sessions



def logged_in? 
  if session[:user_id] 
    true
  else
    false
  end
end


def current_user
  find_one_user_by_id(session[:user_id])
end

get '/' do
  erb :index 
end


get '/login' do
  erb :login
end


post '/login' do
  user = find_one_user_by_email( params[:email] )
  if user && BCrypt::Password.new(user["password_digest"]) == params[:password]
    session[:user_id] = user['id'] 
    redirect "/show_profile"
  else
    erb :login
  end
end


get '/show_profile' do
  user = find_one_user_by_id(session[:user_id])
  erb(:show_profile, locals: { user: user } )
end


get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do

  already_user = find_one_user_by_email( params[:email] )
  if already_user == nil

    create_user(params[:email], params[:password])
    user = find_one_user_by_email( params[:email] )
    session[:user_id] = user['id']

    redirect "/create_profile"
  else
    redirect '/sign_up'
  end
end

get '/create_profile' do
  erb(:create_profile)
end

get '/update_profile' do
  user = find_one_user_by_id(session[:user_id])
  if user['id'] == '46'
    redirect '/show_profile'
  else
    erb(:update_profile)
  end
end

get '/match_page' do
celebs = [
  { :name => "James Thomas", 
    :image_url => "https://images.fineartamerica.com/images-medium-large-5/7-happy-elderly-man-kate-jacobsscience-photo-library.jpg",
    :occupation => "Doctor (of love)",
    :interests => "Sun, surf, and smooching",
    :idea_of_a_good_time => "Having a good old yarn",
    :looking_for_in_a_partner => "A party girl"
  },
  { :name => "Brian Eaton",  
    :image_url => "https://i.pinimg.com/originals/0e/67/2e/0e672ed7c84f7ccceb97add47b35c920.jpg",
    :occupation => "Guru",
    :interests => "Enlightenment",
    :idea_of_a_good_time => "Smoking weed",
    :looking_for_in_a_partner => "Divinity"
  },
  { :name => "Simon Visser",  
    :image_url => "https://cdn.pixabay.com/photo/2017/08/02/14/54/people-2571950__340.jpg",
    :occupation => "Entrepreneur",
    :interests => "Playstation",
    :idea_of_a_good_time => "Kicking back with a whiskey",
    :looking_for_in_a_partner => "Beauty'n booty"
  },
  { :name => "Larry Longing",  
    :image_url => "https://www.catholiccaredbb.org.au/wp-content/uploads/iStock-1012230432_oldmanwithcane.jpg",
    :occupation => "More like preoccupation!",
    :interests => "Yes, I have them",
    :idea_of_a_good_time => "A night on the town (and off the couch). Sigh.",
    :looking_for_in_a_partner => "Someone to lean on"
  },
  { :name => "Hermes Endakis",  
    :image_url => "https://external-preview.redd.it/INAFqxreUIk2_V_IbDUSbLWb7Aqo5zb2DfOYKkhN4xs.gif?format=png8&s=c1aed5247f19f357551e17bc75e59061c01577f8",
    :occupation => "Secuity officer or something",
    :interests => "Sailing",
    :idea_of_a_good_time => "Stopping those meddling  kids",
    :looking_for_in_a_partner => "Justice"
  },
  { :name => "Beatrice Humblebum",  
    :image_url => "https://i.pinimg.com/736x/22/bb/e6/22bbe6ef478246f184a6618f5bb4e01c.jpg",
    :occupation => "Who me? I'm not important.",
    :interests => "What are YOUR interests? :)",
    :idea_of_a_good_time => "I'm not very good at having a good time.",
    :looking_for_in_a_partner => "Someone that likes me."
  },
  { :name => "Ray Meagher",  
    :image_url => "https://oversixtydev.blob.core.windows.net/media/7819537/1.jpg",
    :occupation => "Alf",
    :interests => "Bit'a golf",
    :idea_of_a_good_time => "Struth, I don't know",
    :looking_for_in_a_partner => "A Ferrari chassis"
  },
  { :name => "Alan Jones",  
    :image_url => "https://assets.2ser.com/wp-content/uploads/2019/09/25012554/Screen-Shot-2019-09-24-at-3.25.28-pm-685x368.png",
    :occupation => "Healer",
    :interests => "Feminist theory",
    :idea_of_a_good_time => "Interpretive dance",
    :looking_for_in_a_partner => "A good listener"
  },
  { :name => "Sheila Wheeler", 
    :image_url => "https://p1.piqsels.com/preview/394/535/785/portrait-elderly-woman-old-face-wrinkles-person.jpg",
    :occupation => "Footy diehard",
    :interests => "Footy mate!",
    :idea_of_a_good_time => "Footy mate!",
    :looking_for_in_a_partner => "Full-forward"
  },
  { :name => "Richard Knee", 
    :image_url => "https://www.blackman.com.au/DICKIE%20KNEE.png",
    :occupation => "Entertainer",
    :interests => "Great European literature",
    :idea_of_a_good_time => "Reading philosophy",
    :looking_for_in_a_partner => "Wisdom"
  },
  { :name => "Lady Carole Widdleton", 
    :image_url => "https://image1.masterfile.com/getImage/Njk1LTA1NzcyNjY3ZW4uMDAwMDAwMDA=AEzmwl/695-05772667en_Masterfile.jpg",
    :occupation => "Never needed one",
    :interests => "Watching my wealth grow",
    :idea_of_a_good_time => "Stocks and bondage",
    :looking_for_in_a_partner => "An inheritance"
  },
  { :name => "Jenny Shutterstock", 
    :image_url => "https://i.pinimg.com/originals/80/72/7b/80727b340b3d04d84740f4eae2c93ef4.jpg",
    :occupation => "Hacker",
    :interests => "Your details",
    :idea_of_a_good_time => "Doxxing together",
    :looking_for_in_a_partner => "An accomplice"
  },
  { :name => "Harrold Hiddenpayne", 
    :image_url => "https://thumbs.dreamstime.com/b/portrait-elderly-man-wearing-glasses-closeup-smiling-camera-34462045.jpg",
    :occupation => "Retired",
    :interests => "Nihilism",
    :idea_of_a_good_time => "Endless sleep",
    :looking_for_in_a_partner => "A way out"
  }

]
  user = celebs.sample
  erb(:match_page, locals: {user: user})
end

post '/create_profile' do

  create_profile(params[:name], params[:image_url], params[:gender], params[:occupation], params[:interests], params[:idea_of_a_good_time], params[:looking_for_in_a_partner], session[:user_id])
  redirect "/show_profile"
end

delete '/profile' do
  user = find_one_user_by_id(session[:user_id])
  if user['id'] == '46'
    redirect '/show_profile'
  else
    delete_profile(params[:id])
    session[:user_id] = nil
    redirect '/'
  end
end


delete '/logout' do
  session[:user_id] = nil
  redirect '/'
end
