require 'bcrypt'
require 'pg'

def run_sql(sql, params)
  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: 'dating_app'})
  records = conn.exec_params(sql, params)
  conn.close
  records
end


def create_profile(name, image_url, gender, occupation, interests, idea_of_a_good_time, looking_for_in_a_partner, id)
  sql = <<~SQL
    UPDATE users SET
    name = $1, image_url = $2, gender = $3, occupation = $4, interests = $5, idea_of_a_good_time = $6, looking_for_in_a_partner = $7 WHERE id = $8; 
  SQL
   run_sql(sql, [name, image_url, gender, occupation, interests, idea_of_a_good_time, looking_for_in_a_partner, id])
end

def create_user(email, password)
  password_digest = BCrypt::Password.create(password)
  sql = "INSERT INTO users (email, password_digest) VALUES ($1, $2);"
  run_sql(sql, [email, password_digest])
end

def find_one_user_by_id(id)
  sql = "SELECT * FROM users WHERE id = $1;"
  run_sql(sql, [id])[0]
end

def find_one_user_by_email(email)
  records = run_sql("SELECT * FROM users WHERE email = $1;", [email])
  if records.count == 0
    return nil
  else
    return records[0]
  end
end


def delete_profile(id)
  sql = "DELETE FROM users WHERE id = $1;"
  run_sql(sql, [id])
end




