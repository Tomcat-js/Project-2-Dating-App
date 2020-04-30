     
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
  erb(:update_profile)
end

get '/match_page' do
celebs = [
  { :name => "Ryan Moloney", 
    :gender => "Male", 
    :image_url => "https://www.pedestrian.tv/content/uploads/2019/03/Toadfishrebecchi-637x375.png",
    :occupation => "Toadie",
    :interests => "Sun, surf, and sex",
    :idea_of_a_good_time => "Having a good old yarn",
    :looking_for_in_a_partner => "A girl who knows what she wants"
  },
  { :name => "Sam Newman", 
    :gender => "Yes", 
    :image_url => "https://cdn.newsapi.com.au/image/v1/361ebab2b9476ecdf6dd1e895328e72f?width=650",
    :occupation => "Talentless celebrity",
    :interests => "Myself",
    :idea_of_a_good_time => "A good cry wank",
    :looking_for_in_a_partner => "A female version of me"
  },
  { :name => "Kyle Sandilands", 
    :gender => "Nothin' gay", 
    :image_url => "https://www.bandt.com.au/information/uploads/2017/05/ae77f77de92f32dbe50bd6e82ef8302b.jpg",
    :occupation => "What?",
    :interests => "Jokes'n that",
    :idea_of_a_good_time => "Bathing in my own filth",
    :looking_for_in_a_partner => "Sex"
  },
  { :name => "Larry Emdur", 
    :gender => "Male", 
    :image_url => "https://d3lp4xedbqa8a5.cloudfront.net/s3/digital-cougar-assets/now/2020/03/06/1583454578945_tpir.jpg?width=768&height=639&quality=75&mode=crop&anchor=topcenter",
    :occupation => "Host with the most",
    :interests => "Board games",
    :idea_of_a_good_time => "A night on the couch",
    :looking_for_in_a_partner => "A sense of humour"
  },
  { :name => "Hermes Endakis", 
    :gender => "Male", 
    :image_url => "https://m.media-amazon.com/images/M/MV5BNjk4YjQxNGYtZGU0ZS00OWY3LWIyYzMtNmIzYWQ2MzY4YzUxXkEyXkFqcGdeQXVyNTE1NjY5Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg",
    :occupation => "Secuity officer or something",
    :interests => "Sailing",
    :idea_of_a_good_time => "Stopping those meddling  kids",
    :looking_for_in_a_partner => "Beauty"
  },
  { :name => "Jason Donovan", 
    :gender => "Male", 
    :image_url => "https://img.discogs.com/Ht-WbYVFUr-2FNMCXHmhelB-Wf8=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1223507-1545570250-6987.jpeg.jpg",
    :occupation => "Talent",
    :interests => "Grooming",
    :idea_of_a_good_time => "Swooning",
    :looking_for_in_a_partner => "Booty"
  },
  { :name => "Ray Meagher", 
    :gender => "All man", 
    :image_url => "https://oversixtydev.blob.core.windows.net/media/7819537/1.jpg",
    :occupation => "Alf",
    :interests => "Bit a golf",
    :idea_of_a_good_time => "Stuth I don't know",
    :looking_for_in_a_partner => "A Ferrari chassis"
  },
  { :name => "Alan Jones", 
    :gender => "Non-binary", 
    :image_url => "https://assets.2ser.com/wp-content/uploads/2019/09/25012554/Screen-Shot-2019-09-24-at-3.25.28-pm-685x368.png",
    :occupation => "Healer",
    :interests => "Feminist theory",
    :idea_of_a_good_time => "Expressing the fire of the earth mother through interpretative dance",
    :looking_for_in_a_partner => "A strong feminine energy"
  },
  { :name => "Eddie McGuire", 
    :gender => "Man", 
    :image_url => "https://cdn.newsapi.com.au/image/v1/3faa74eb4dd7b27e827b1eca3400e91e?width=1024",
    :occupation => "Bloody AFL mate",
    :interests => "Footy mate!",
    :idea_of_a_good_time => "Footy mate!",
    :looking_for_in_a_partner => "Foot... fetish"
  },
  { :name => "Dickie Knee", 
    :gender => "Unknown", 
    :image_url => "https://www.blackman.com.au/DICKIE%20KNEE.png",
    :occupation => "Entertainer",
    :interests => "Great European literature",
    :idea_of_a_good_time => "Reading philosophy",
    :looking_for_in_a_partner => "Wisdom"
  },

]
  user = celebs.sample
  erb(:match_page, locals: {user: user})
end

post '/create_profile' do

  create_profile(params[:name], params[:image_url], params[:gender], params[:occupation], params[:interests], params[:idea_of_a_good_time], params[:looking_for_in_a_partner], session[:user_id])
  redirect "/show_profile"
end

delete '/profile' do
  delete_profile(params[:id])
  session[:user_id] = nil
  redirect '/'
end


delete '/logout' do
  session[:user_id] = nil
  redirect '/'
end
