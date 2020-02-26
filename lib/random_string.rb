module RandomString
  def generate_random_string
    str = (0..20).map do
      total_no = 0
      rnd_no = rand(36)
      if (rnd_no < 10)
        total_no = 48 + rnd_no
      else
        total_no = 55 + rnd_no
      end
        total_no.chr
    end.join

    str
  end
end

