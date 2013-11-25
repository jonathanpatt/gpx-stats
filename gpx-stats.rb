require 'gpx'
require 'haversine'

@ascent = @descent = 0
@ascent_grade = @descent_grade = 0
@distance = @ascent_distance = @descent_distance = @flat_distance = 0
@prev_lat = @prev_lon = @prev_elevation = @prev_time = 0

unless gpx_file = ARGV[0]
  puts "ERROR: You must provide the path to a valid gpx file."
  abort
end

gpx = GPX::GPXFile.new(gpx_file: gpx_file)

gpx.tracks.each do |t|
  t.points.each do |p|
    # Skip calculations for the first point since there's no previous data
    if @prev_lat > 0
      # Get distance between current and previous point and convert to miles
      d = Haversine.distance(p.lat, p.lon, @prev_lat, @prev_lon) * 0.6214
      @distance += d

      if p.elevation > @prev_elevation
        @ascent += (p.elevation - @prev_elevation)
        @ascent_distance += d
      elsif p.elevation < @prev_elevation
        @descent += (@prev_elevation - p.elevation)
        @descent_distance += d
      else
        @flat_distance += d
      end
    end

    @prev_lat, @prev_lon, @prev_elevation, @prev_time = [p.lat, p.lon, p.elevation, p.time]
  end
end

# Convert ascent and descent to feet
@ascent = (@ascent * 3.281).round
@descent = (@descent * 3.281).round

@ascent_grade = (100 * (@ascent / (@ascent_distance * 5280))).abs.round(1) unless @ascent == 0
@descent_grade = (100 * (@descent / (@descent_distance * 5280))).abs.round(1) unless @descent == 0
@total_grade = (100 * ((@ascent - @descent) / (@distance * 5280))).abs.round(1) unless @ascent == 0 or @descent == 0

puts "#{@ascent} ft. ascent, #{@descent} ft. descent"
puts "#{@ascent_distance.round(2)} mi. ascending, #{@descent_distance.round(2)} mi. descending, #{@flat_distance.round(2)} mi. flat, #{@distance.round(2)} mi. total"
puts "#{@ascent_grade}% ascent grade, #{@descent_grade}% descent grade, #{@total_grade}% total grade"
