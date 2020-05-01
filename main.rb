     
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
  if user['id'] == '41'
    redirect '/show_profile'
  else
    erb(:update_profile)
  end
end

get '/match_page' do
celebs = [
  { :name => "Ryan Moloney", 
    :image_url => "https://www.pedestrian.tv/content/uploads/2019/03/Toadfishrebecchi-637x375.png",
    :occupation => "Toadie",
    :interests => "Sun, surf, and sex",
    :idea_of_a_good_time => "Having a good old yarn",
    :looking_for_in_a_partner => "A party girl"
  },
  { :name => "Sam Newman",  
    :image_url => "https://cdn.newsapi.com.au/image/v1/361ebab2b9476ecdf6dd1e895328e72f?width=650",
    :occupation => "Talentless celebrity",
    :interests => "Myself",
    :idea_of_a_good_time => "A good cry wank",
    :looking_for_in_a_partner => "A female version of me"
  },
  { :name => "Kyle Sandilands",  
    :image_url => "https://www.bandt.com.au/information/uploads/2017/05/ae77f77de92f32dbe50bd6e82ef8302b.jpg",
    :occupation => "What?",
    :interests => "Jokes'n that",
    :idea_of_a_good_time => "Looking in the mirror",
    :looking_for_in_a_partner => "Sex"
  },
  { :name => "Larry Emdur",  
    :image_url => "https://d3lp4xedbqa8a5.cloudfront.net/s3/digital-cougar-assets/now/2020/03/06/1583454578945_tpir.jpg?width=768&height=639&quality=75&mode=crop&anchor=topcenter",
    :occupation => "Host with the most",
    :interests => "Board games",
    :idea_of_a_good_time => "A night on the couch",
    :looking_for_in_a_partner => "A sense of humour"
  },
  { :name => "Hermes Endakis",  
    :image_url => "https://external-preview.redd.it/INAFqxreUIk2_V_IbDUSbLWb7Aqo5zb2DfOYKkhN4xs.gif?format=png8&s=c1aed5247f19f357551e17bc75e59061c01577f8",
    :occupation => "Secuity officer or something",
    :interests => "Sailing",
    :idea_of_a_good_time => "Stopping those meddling  kids",
    :looking_for_in_a_partner => "Beauty"
  },
  { :name => "Jason Donovan",  
    :image_url => "https://img.discogs.com/Ht-WbYVFUr-2FNMCXHmhelB-Wf8=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-1223507-1545570250-6987.jpeg.jpg",
    :occupation => "Talent",
    :interests => "Grooming",
    :idea_of_a_good_time => "Swooning",
    :looking_for_in_a_partner => "Booty"
  },
  { :name => "Ray Meagher",  
    :image_url => "https://oversixtydev.blob.core.windows.net/media/7819537/1.jpg",
    :occupation => "Alf",
    :interests => "Bit a golf",
    :idea_of_a_good_time => "Struth, I don't know",
    :looking_for_in_a_partner => "A Ferrari chassis"
  },
  { :name => "Alan Jones",  
    :image_url => "https://assets.2ser.com/wp-content/uploads/2019/09/25012554/Screen-Shot-2019-09-24-at-3.25.28-pm-685x368.png",
    :occupation => "Healer",
    :interests => "Feminist theory",
    :idea_of_a_good_time => "Expressing the fire of the earth mother through interpretative dance",
    :looking_for_in_a_partner => "A strong feminine energy"
  },
  { :name => "Eddie McGuire", 
    :image_url => "https://cdn.newsapi.com.au/image/v1/3faa74eb4dd7b27e827b1eca3400e91e?width=1024",
    :occupation => "Bloody AFL mate",
    :interests => "Footy mate!",
    :idea_of_a_good_time => "Footy mate!",
    :looking_for_in_a_partner => "Foot... fetish"
  },
  { :name => "Dickie Knee", 
    :image_url => "https://www.blackman.com.au/DICKIE%20KNEE.png",
    :occupation => "Entertainer",
    :interests => "Great European literature",
    :idea_of_a_good_time => "Reading philosophy",
    :looking_for_in_a_partner => "Wisdom"
  },
  { :name => "Karl Stefanovic", 
    :image_url => "https://d2nzqyyfd6k6c7.cloudfront.net/styles/nova_evo_landscape/s3/article/thumbnail/karl_stefanovic_0.jpg?itok=DEU-21SC",
    :occupation => "Professional larrikin",
    :interests => "Sundays",
    :idea_of_a_good_time => "Havin' a laugh",
    :looking_for_in_a_partner => "Someone younger"
  },
  { :name => "Tony Abbott", 
    :image_url => "https://sportsocratic.com/wp-content/uploads/2016/09/140923-tony-abbott-speedos.jpg",
    :occupation => "Illegal Avian Importer (Budgie Smuggler)",
    :interests => "Beaches and BBQs",
    :idea_of_a_good_time => "Watersports",
    :looking_for_in_a_partner => "A good Christian lass"
  },
  { :name => "George Calombaris", 
    :image_url => "https://nnimgt-a.akamaihd.net/transform/v1/crop/frm/silverstone-feed-data/b86ade7b-d751-4d6e-966a-e7e07a33b1d6.jpg/r0_0_800_600_w1200_h678_fmax.jpg",
    :occupation => "Chef",
    :interests => "Frugality",
    :idea_of_a_good_time => "Eating",
    :looking_for_in_a_partner => "An appetite for love"
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
  if user['id'] == '41'
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
