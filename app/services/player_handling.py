class player_handling:
    def __init__(self):
        self.players = []

    def add_player(self, player):
        if player:
            self.players.append(player)

    def get_players(self):
        return self.players

    def remove_player(self, player):
        if player in self.players:
            self.players.remove(player)

