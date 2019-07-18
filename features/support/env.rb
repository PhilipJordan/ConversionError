
require 'watir'


client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 300


browser = Watir::Browser.new :chrome, :http_client => client, 'chromeOptions' => {"args" => ["--start-maximized", "--disable-infobars"]}






Before do
  @browser = browser
end
