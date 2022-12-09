require_relative './game'

class MarkdownGenerator
  IMAGE_BASE_URL = 'https://raw.githubusercontent.com/fletchertyler914/fletchertyler914/main/images'
  ISSUE_BASE_URL = 'https://github.com/fletchertyler914/fletchertyler914/issues/new'
  ISSUE_BODY = 'body=Just+push+%27Submit+new+issue%27+without+editing+the+title.+The+README+will+be+updated+after+approximately+30+seconds.'

  RED_IMAGE = "![](#{IMAGE_BASE_URL}/red.png)"
  BLUE_IMAGE = "![](#{IMAGE_BASE_URL}/blue.png)"
  BLANK_IMAGE = "![](#{IMAGE_BASE_URL}/blank.png)"

  def initialize(game:)
    @game = game
  end

  def readme(metadata:, recent_moves:)
    current_turn = game.current_turn

    total_moves_played = metadata[:all_players].values.sum
    completed_games = metadata[:completed_games]
    game_winning_players = metadata[:game_winning_players].sort_by { |_, wins| -wins }

    markdown = <<~HTML
      <h1 align="center">
              <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="35">
              <b>Hey, I'm Tyler Fletcher</b>
            </h1>

        <p align="center">
          <a href="https://github.com/DenverCoder1/readme-typing-svg"><img src="https://readme-typing-svg.herokuapp.com?font=Time+New+Roman&color=cyan&size=25&center=true&vCenter=true&width=600&height=100&lines=Tyler+Fletcher;self-taught-full-stack;solana<3;terminally-curious;oss<3"></a>
        </p>

        <br>

      <h2 align='center'> <picture><img src = "https://github.com/0xAbdulKhalid/0xAbdulKhalid/raw/main/assets/mdImages/about_me.gif" width = 50px></picture> <b>About me</b></h2>

      <picture> <img align="right" src="https://github.com/0xAbdulKhalid/0xAbdulKhalid/raw/main/assets/mdImages/Right_Side.gif" width = 250px></picture>

        <br>

      - A terminally-curious self-taught full-stack developer
      - Building on [Solana](https://solana.com) full-time with [NATION](https://nation.io)
      - Currently learning [anchor](https://www.anchor-lang.com/)/rust, and looking into [qwik](https://qwik.builder.io/)
      - [Personal website](https://tylerjfletcher.xyz) (under construction/outdated :p)
      - 3 kids that drive me insane in the best way

      <br><br><br>

      <h2 align='center'><img src="https://media.giphy.com/media/iY8CRBdQXODJSCERIr/giphy.gif" width="35"><b> Github Stats </b></h2>

        <br>

        <div align="center">

        <a href="https://github.com/fletchertyler914/">
          <br>
          <img src="https://github-readme-stats.vercel.app/api?username=fletchertyler914&include_all_commits=true&count_private=true&show_icons=true&line_height=20&title_color=7A7ADB&icon_color=2234AE&text_color=D3D3D3&bg_color=0,000000,130F40" width="565"/>
          <br><br><br>
          <img src="https://github-readme-stats.vercel.app/api/top-langs?username=fletchertyler914&show_icons=true&locale=en&layout=compact&line_height=20&title_color=7A7ADB&icon_color=2234AE&text_color=D3D3D3&bg_color=0,000000,130F40" width="400"  alt="fletchertyler914"/>

        </a>

      <br><br>

      <h2 align='center'> <img src="https://github.com/0xAbdulKhalid/0xAbdulKhalid/raw/main/assets/mdImages/handshake.gif" width ="80"><br><b>Connect</b></h2>

        <a href="https://www.linkedin.com/in/tyler-fletcher/" target="_blank">
        <img src="https://img.shields.io/badge/linkedin:  tyler--fletcher-%2300acee.svg?color=405DE6&style=for-the-badge&logo=linkedin&logoColor=white" alt=linkedin style="margin-bottom: 5px;"/>
        </a>

        <br>

        <a href="https://twitter.com/firecrab_" target="_blank">
        <img src="https://img.shields.io/badge/twitter:  firecrab__-%2300acee.svg?color=1DA1F2&style=for-the-badge&logo=twitter&logoColor=white" alt=twitter style="margin-bottom: 5px;"/>
        </a>
        </li>

        <br>

        <a href="mailto:hello@tylerjfletcher.xyz" target="_blank">
        <img src="https://img.shields.io/badge/proton:  tylerjfletcher.xyz-6D4AFF.svg?style=for-the-badge&logo=protonmail&logoColor=white" t=mail style="margin-bottom: 5px;" />
        </a>

      <br>

      <img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

      <br>

      <b> :game_die: Join my community Connect Four game! <b>

      ![](https://img.shields.io/badge/Moves%20played-2-blue)
      ![](https://img.shields.io/badge/Completed%20games-0-brightgreen)
      ![](https://img.shields.io/badge/Total%20players-1-orange)

      Everyone is welcome to participate! To make a move, click on the **column number** you wish to drop your disk in.
      <br>

      <img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

      <br>
    HTML

    game_status = if game.over?
      "#{game.status_string} [Click here to start a new game!](#{ISSUE_BASE_URL}?title=connect4%7Cnew&#{ISSUE_BODY})\n\n"
    else
      "It is the <b>#{current_turn}<b> team's turn to play.<br>"
    end

    markdown.concat("#{game_status}\n\n")

    markdown.concat(generate_game_board)

    unless game.over?
          markdown.concat <<~HTML
          
          ---

          Tired of waiting?<br>
          [Request an AI move](#{ISSUE_BASE_URL}?title=connect4%7Cdrop%7C#{current_turn}%7Cai&#{ISSUE_BODY})
          HTML
    end

    markdown.concat <<~HTML

        Interested in how everything works? <br>
        [Read more here](https://github.com/fletchertyler914/fletchertyler914/tree/main/connect4)
        
        ---

        **:alarm_clock: Most recent moves**
        | Team | Move | Made by |
        | ---- | ---- | ------- |
    HTML

    recent_moves.each { |(team, move, user)| markdown.concat("| #{team} | #{move} | #{user} |\n") }

    markdown.concat <<~HTML
        ---

        **:trophy: Leaderboard: Top 10 players with the most game winning moves :1st_place_medal:**
        | Player | Wins |
        | ------ | -----|
    HTML

    game_winning_players.first(10).each do |player, wins|
      user = if player == 'Connect4Bot'
        'Connect4Bot :robot:'
      else
        "[@#{player}](https://github.com/#{player})"
      end
      markdown.concat("| #{user} | #{wins} |\n")
    end
    markdown.concat <<~HTML

        ---

        Profile inspired by: [Abdul Khalid](https://github.com/0xabdulkhalid) and [JonathanGin52](https://github.com/JonathanGin52)<br>
        Last Edited on: December 8th, 2022
    HTML
    markdown
  end

  def game_over_message(red_team:, blue_team:)
    winner = game.winner
    victory_text = if winner.nil?
      'The game ended in a draw, how anticlimactic!'
    else
      "The **#{winner}** team has emerged victorious! :trophy:"
    end

    <<~HTML
      # :tada: The game has ended :confetti_ball:
      #{victory_text}

      [Click here to start a new game!](#{ISSUE_BASE_URL}?title=connect4%7Cnew&#{ISSUE_BODY})

      ### :star: Game board
      #{generate_game_board}

      ## Thank you to everybody who participated!

      ### Red team roster
      #{generate_player_moves_table(red_team)}

      ### Blue team roster
      #{generate_player_moves_table(blue_team)}

      <br><br>

      Profile inspired by: [0xabdulkhalid](https://github.com/0xabdulkhalid) and [JonathanGin52](https://github.com/JonathanGin52)

      Last Edited on: December 8th, 2022

      </div>
    HTML
  end

  private

  attr_reader :game

  def generate_game_board
    valid_moves = game.valid_moves
    current_turn = game.current_turn
    headers = if valid_moves.empty?
      '1|2|3|4|5|6|7'
    else
      (1..7).map do |column|
        if valid_moves.include?(column)
          "[#{column}](#{ISSUE_BASE_URL}?title=connect4%7Cdrop%7C#{current_turn}%7C#{column}&#{ISSUE_BODY})"
        else
          column.to_s
        end
      end.join('|')
    end

    game_board = "|#{headers}|\n| - | - | - | - | - | - | - |\n"

    5.downto(0) do |row|
      format = (0...7).map do |col|
        offset = row + 7 * col
        if ((game.bitboards[0] >> offset) & 1) == 1
          RED_IMAGE
        elsif ((game.bitboards[1] >> offset) & 1) == 1
          BLUE_IMAGE
        else
          BLANK_IMAGE
        end
      end
      game_board.concat("|#{format.join('|')}|\n")
    end
    game_board
  end

  def generate_player_moves_table(player_moves)
    table = "| Player | Moves made |\n| - | - |\n"
    player_moves.sort_by { |_, move_count| -move_count }.reduce(table) do |tbl, (player, move_count)|
      tbl.concat("| #{player} | #{move_count} |\n")
    end
  end
end
