defmodule TrafficLight do

  require Logger

  @gpio_red     22
  @gpio_amber   23
  @gpio_green   24
  @gpio_switch  17

  # 1000 milliseconds = 1 second
  @time_amber  5_000
  @time_red    15_000
  @time_green  15_000 

  def start(_type, _args) do
    Logger.debug "start"
    spawn fn -> traffic_lights end
    {:ok, self }
  end

  def traffic_lights do
    Logger.debug "traffic lights"
    {:ok, green_light}  = Gpio.start_link(24,  :output)
    {:ok, amber_light}  = Gpio.start_link(23,  :output)
    {:ok, red_light}    = Gpio.start_link(22,  :output)
    # TODO {:ok, switch}       = Gpio.start_link(gpio_switch, :input)

    Logger.debug "setup complete"
    # start with red
    Gpio.write(red_light,   1)
    Gpio.write(green_light, 0)
    Gpio.write(amber_light, 0)

    :timer.sleep 15_000

    light_sequence(green_light, amber_light, red_light)
  end


  def light_sequence(green_light, amber_light, red_light) do
    # change to green
    Logger.debug "gree traffic light"
    Gpio.write(green_light, 1)
    Gpio.write(red_light,   0)

    :timer.sleep 15_000

    # change to amber
    Gpio.write(amber_light, 1)
    Gpio.write(green_light, 0)

    :timer.sleep 5_000 

    #change to red
    Gpio.write(red_light,   1)
    Gpio.write(amber_light, 0)
    
    :timer.sleep 15_000

    light_sequence(green_light, amber_light, red_light)
  end
end

# # loops until Gpio becomes "False" ie switch pressed
# while Gpio.input(Gpio_SWITCH):
# # sleep used to reduce processor usage
# #sleep for 1/4 sec between checking switch
# time.sleep (0.25)

# iex> {:ok, pid} = Gpio.start_link(17, :input)
# {:ok, #PID<0.97.0>}

# iex> Gpio.read(pid)
# 0

# # Push the button down

# iex> Gpio.read(pid)
# 1
# end
