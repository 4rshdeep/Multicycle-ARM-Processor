class Board:
	def __init__(self):
		self.board = [['_' for x in range(8)] for y in range(8)]
		self.board[3][3] = 'W'
		self.board[4][3] = 'B'
		self.board[3][4] = 'B'
		self.board[4][4] = 'W'
		self.WScore = 0 # white score
		self.BScore = 0 # black score
		self.remaining = 0
		# row = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'] 
	
	# board = [[0 for x in range(8)] for y in range(8)]


	class Point(object):
		def __init__(self, x, y):
			self.x = x
			self.y = y

		def toString():
			return "["+self.x+", "+self.y+"]"

		def equals(o):
			return o.hashcode() == self.hashcode()

		def hashcode():
			return int(self.x+""+self.y)


	def display_board(self):
		row = ['  ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'] 
		for ch in row:
			print(ch, end=" ")
		print()
		for i in range(8):
			print(str(i+1)+" ", end=" ")
			for j in range(8):
				print(self.board[i][j], end=" ")

			print()
	

b = Board()
b.display_board()
# b = Board()
# Matrix = [[0 for x in range(8)] for y in range(8)]
# print(Matrix[0][0]) 