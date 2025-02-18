# frozen_string_literal: true

RSpec.describe TTY::Logger, "#log" do
  let(:output) { StringIO.new }
  let(:styles) { TTY::Logger::Handlers::Console::STYLES }

  it "logs a message at debug level" do
    logger = TTY::Logger.new(output: output) do |config|
      config.level = :debug
    end

    logger.debug("Successfully", "deployed")

    expect(output.string).to eq([
      "\e[36m#{styles[:debug][:symbol]}\e[0m ",
      "\e[36mdebug\e[0m   ",
      "Successfully deployed    \n"].join)
  end

  it "logs a message at info level" do
    logger = TTY::Logger.new(output: output)

    logger.info("Successfully", "deployed")

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Successfully deployed    \n"].join)
  end

  it "logs a message at warn level" do
    logger = TTY::Logger.new(output: output)

    logger.warn("Failed to", "deploy")

    expect(output.string).to eq([
      "\e[33m#{styles[:warn][:symbol]}\e[0m ",
      "\e[33mwarning\e[0m ",
      "Failed to deploy         \n"].join)
  end

  it "logs a message at error level" do
    logger = TTY::Logger.new(output: output)

    logger.error("Failed to", "deploy")

    expect(output.string).to eq([
      "\e[31m#{styles[:error][:symbol]}\e[0m ",
      "\e[31merror\e[0m   ",
      "Failed to deploy         \n"].join)
  end

  it "logs a message at fatal level" do
    logger = TTY::Logger.new(output: output)

    logger.fatal("Failed to", "deploy")

    expect(output.string).to eq([
      "\e[31m#{styles[:fatal][:symbol]}\e[0m ",
      "\e[31mfatal\e[0m   ",
      "Failed to deploy         \n"].join)
  end

  it "logs a success message at info level" do
    logger = TTY::Logger.new(output: output)

    logger.success("Deployed", "successfully")

    expect(output.string).to eq([
      "\e[32m#{styles[:success][:symbol]}\e[0m ",
      "\e[32msuccess\e[0m ",
      "Deployed successfully    \n"].join)
  end

  it "logs a wait message at info level" do
    logger = TTY::Logger.new(output: output)

    logger.wait("Waiting for", "deploy")

    expect(output.string).to eq([
      "\e[36m#{styles[:wait][:symbol]}\e[0m ",
      "\e[36mwaiting\e[0m ",
      "Waiting for deploy       \n"].join)
  end

  it "logs a message in a block" do
    logger = TTY::Logger.new(output: output) do |config|
      config.level = :debug
    end

    logger.info { "Successfully deployed" }

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Successfully deployed    \n"].join)
  end

  it "doesn't log when lower level" do
    logger = TTY::Logger.new(output: output) do |config|
      config.level = :warn
    end

    logger.debug("Successfully deployed")

    expect(output.string).to eq("")
  end

  it "logs message with global fields" do
    logger = TTY::Logger.new(output: output, fields: {app: 'myapp', env: 'prod'})

    logger.info("Successfully deployed")

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Successfully deployed     ",
      "\e[32mapp\e[0m=myapp \e[32menv\e[0m=prod\n"].join)
  end

  it "logs message with fields" do
    logger = TTY::Logger.new(output: output)

    logger.with(app: 'myapp', env: 'prod').info("Successfully deployed")

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Successfully deployed     ",
      "\e[32mapp\e[0m=myapp \e[32menv\e[0m=prod\n"].join)
  end

  it "logs message with scoped fields" do
    logger = TTY::Logger.new(output: output)

    logger.info("Successfully deployed", app: 'myapp', env: 'prod')

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Successfully deployed     ",
      "\e[32mapp\e[0m=myapp \e[32menv\e[0m=prod\n"].join)
  end
end
