import java.util.*;
import java.util.HashSet;
import java.util.Scanner;

public class My_Othello{
    static final char boardX[] = new char[]{'A','B','C','D','E','F','G','H'};

	static char[][] board = new char[][]{
        {'_','_','_','_','_','_','_','_',},
        {'_','_','_','_','_','_','_','_',},
        {'_','_','_','_','_','_','_','_',},
        {'_','_','_','W','B','_','_','_',},
        {'_','_','_','B','W','_','_','_',},
        {'_','_','_','_','_','_','_','_',},
        {'_','_','_','_','_','_','_','_',},
        {'_','_','_','_','_','_','_','_',},
    };
	static check moves;

    public static void displayBoard(){  
                // b.board[0][1]='A'; y x
        System.out.print("\n  ");
        for(int i=0;i<8;++i)System.out.print(boardX[i]+" ");// displays ABCDEF..
            System.out.println();
        for(int i=0;i<8;++i){
            System.out.print((i+1)+" "); // displays row numbers
            for(int j=0;j<8;++j)
                System.out.print(board[i][j]+" ");
            System.out.println();
        }
        System.out.println(); 
    }

	static class Point{
        int x, y;
        Point(int x, int y){
            this.x = x;
            this.y = y;
        }
    }    

    static Boolean check_move(Boolean B_turn, Point t){
        Boolean ans = false;
        if(B_turn){
            for(Point p : moves.B_moves){
                if(p.x==t.x && p.y==t.y){ans = true; break;}
            }
        }
        else{
            for(Point p : moves.W_moves){
                if(p.x==t.x && p.y==t.y){ans = true; break;}
            }   
        }
        return ans;
    }

    static void print_moves(char x){
        if(x == 'W'){
            for(Point p:moves.W_moves){
                System.out.println("X:" + p.x + " Y:" + p.y);
            }
        }
        else{
            for(Point p:moves.B_moves){
                System.out.println("X:" + p.x + " Y:" + p.y);
            }   
        }
    }

    static void find_score(){
        int w = 0;
        int b = 0;
        for(int i=0; i<8; i++){
            for(int j=0; j<8; j++){
                if(board[i][j]=='W') w++;
                else if(board[i][j]=='B') b++;
            }
        }
        String str;
        if(w>b) str = "Winner is Player W.\n";
        else if(b>w) str = "Winner is Player B.\n"; 
        else str = "It's a tie.\n" ;
        System.out.println("Score for Player W: " + w + "\n" + "Score for Player B: " + b +"\n"  + str); 
    }

	static class check{
		static Boolean W_avail;
		static Boolean B_avail;
		static HashSet<Point> W_moves = new HashSet<>();
		static HashSet<Point> B_moves = new HashSet<>();
	}

    static void insert(char x, char y, Point t){
        // System.out.println("HELLO.... INSERT " + x + " " + y + " x:"+ t.x +" y:" + t.y);
        if(x=='W') moves.W_moves.add(t);
        else moves.B_moves.add(t);
    }

	static void find_moves(char x, char y){
        if(x=='W') moves.W_moves = new HashSet<>();
        else moves.B_moves = new HashSet<>();
		for(int i=0;i<8;++i){
            for(int j=0;j<8;++j){
                if(board[i][j] == y){
                    int I = i, J = j;  
                    if(i-1>=0 && j-1>=0 && board[i-1][j-1] == '_'){ 
                        i = i+1; j = j+1;
                        while(i<7 && j<7 && board[i][j] == y){i++;j++;}
                        if(i<=7 && j<=7 && board[i][j] == x) insert(x,y,new Point(I-1, J-1));
                    } 
                    i=I;j=J;
                    if(i-1>=0 && board[i-1][j] == '_'){
                        i = i+1;
                        while(i<7 && board[i][j] == y) i++;
                        if(i<=7 && board[i][j] == x) insert(x,y,new Point(I-1, J));
                    } 
                    i=I;
                    if(i-1>=0 && j+1<=7 && board[i-1][j+1] == '_'){
                        i = i+1; j = j-1;
                        while(i<7 && j>0 && board[i][j] == y){i++;j--;}
                        if(i<=7 && j>=0 && board[i][j] == x) insert(x,y,new Point(I-1, J+1));
                    }  
                    i=I;j=J;
                    if(j-1>=0 && board[i][j-1] == '_'){
                        j = j+1;
                        while(j<7 && board[i][j] == y)j++;
                        if(j<=7 && board[i][j] == x) insert(x,y,new Point(I, J-1));
                    }
                    j=J;
                    if(j+1<=7 && board[i][j+1] == '_'){
                        j=j-1;
                        while(j>0 && board[i][j] == y)j--;
                        if(j>=0 && board[i][j] == x) insert(x,y,new Point(I, J+1));
                    }
                    j=J;
                    if(i+1<=7 && j-1>=0 && board[i+1][j-1] == '_'){
                        i=i-1;j=j+1;
                        while(i>0 && j<7 && board[i][j] == y){i--;j++;}
                        if(i>=0 && j<=7 && board[i][j] == x) insert(x,y,new Point(I+1, J-1));
                    }
                    i=I;j=J;
                    if(i+1 <= 7 && board[i+1][j] == '_'){
                        i=i-1;
                        while(i>0 && board[i][j] == y) i--;
                        if(i>=0 && board[i][j] == x) insert(x,y,new Point(I+1, J));
                    }
                    i=I;
                    if(i+1 <= 7 && j+1 <=7 && board[i+1][j+1] == '_'){
                        i=i-1;j=j-1;
                        while(i>0 && j>0 && board[i][j] == y){i--;j--;}
                        if(i>=0 && j>=0 && board[i][j] == x)insert(x,y,new Point(I+1, J+1));
                    }
                    i=I;j=J;
                    }
                } 
        }
	moves.W_avail = !(moves.W_moves.isEmpty());
    moves.B_avail = !(moves.B_moves.isEmpty());
    }
	
    // static void set_move(Point place, Boolean B_turn){
    //     if(B_turn)  board[place.x][place.y] = 'B';
    //     else board[place.x][place.y] = 'W';
    //     displayBoard();
    // }

    static void set_move(Point p, Boolean B_turn){
        char player, opponent;
        if(B_turn){
            player = 'B';
            opponent = 'W';
        }
        else{
            player = 'W';
            opponent = 'B';
        }
        int i = p.x, j = p.y;
        board[i][j] = player; 
        int I = i, J = j;  
        
        if(i-1>=0 && j-1>=0 && board[i-1][j-1] == opponent){ 
            i = i-1; j = j-1;
            while(i>0 && j>0 && board[i][j] == opponent){i--;j--;}
            if(i>=0 && j>=0 && board[i][j] == player) {while(i!=I-1 && j!=J-1)board[++i][++j]=player;}
        } 
        i=I;j=J; 
        if(i-1>=0 && board[i-1][j] == opponent){
            i = i-1;
            while(i>0 && board[i][j] == opponent) i--;
            if(i>=0 && board[i][j] == player) {while(i!=I-1)board[++i][j]=player;}
        } 
        i=I; 
        if(i-1>=0 && j+1<=7 && board[i-1][j+1] == opponent){
            i = i-1; j = j+1;
            while(i>0 && j<7 && board[i][j] == opponent){i--;j++;}
            if(i>=0 && j<=7 && board[i][j] == player) {while(i!=I-1 && j!=J+1)board[++i][--j] = player;}
        }   
        i=I;j=J;
        if(j-1>=0 && board[i][j-1] == opponent){
            j = j-1;
            while(j>0 && board[i][j] == opponent)j--;
            if(j>=0 && board[i][j] == player) {while(j!=J-1)board[i][++j] = player;}
        }
        j=J; 
        if(j+1<=7 && board[i][j+1] == opponent){
            j=j+1;
            while(j<7 && board[i][j] == opponent)j++;
            if(j<=7 && board[i][j] == player) {while(j!=J+1)board[i][--j] = player;}
        }
        j=J; 
        if(i+1<=7 && j-1>=0 && board[i+1][j-1] == opponent){ 
            i=i+1;j=j-1;
            while(i<7 && j>0 && board[i][j] == opponent){i++;j--;}
            if(i<=7 && j>=0 && board[i][j] == player) {while(i!=I+1 && j!=J-1)board[--i][++j] = player;}
        }
        i=I;j=J; 
        if(i+1 <= 7 && board[i+1][j] == opponent){ 
            i=i+1;
            while(i<7 && board[i][j] == opponent) i++;
            if(i<=7 && board[i][j] == player) {while(i!=I+1)board[--i][j] = player;}
        }
        i=I;

        if(i+1 <= 7 && j+1 <=7 && board[i+1][j+1] == opponent){
            i=i+1;j=j+1;
            while(i<7 && j<7 && board[i][j] == opponent){i++;j++;}
            if(i<=7 && j<=7 && board[i][j] == player)while(i!=I+1 && j!=J+1)board[--i][--j] = player;}
            displayBoard();
    }  





	public static void main(String[] args){
        Scanner s = new Scanner(System.in);
        Boolean B_turn = true;
        displayBoard();
        Boolean flag = true;

        while(true){
            if(flag){
                find_moves('B','W');
                find_moves('W','B');
            }




            if(!(moves.B_avail) && !(moves.W_avail)) {
                System.out.println("Game Ended"); 
                find_score();
                break; 
            }  
            if(B_turn) {
                if(moves.B_avail) {
                    System.out.println("Player Black choose your move :");
                    int x = Integer.parseInt(s.next()) -1;
                    int y = (s.next()).charAt(0) - 'A';
                    Point ttry = new Point(x,y);
                    if(!(check_move(B_turn,ttry))){
                        flag = false;
                        System.out.println("Invalid move, try again");
                        continue;
                    }
                    else{
                        set_move(ttry, B_turn);
                        B_turn = ! B_turn;
                        flag = true;
                        continue;
                    }
                }
                else{
                    System.out.println("No legal moves for Player B");
                    System.out.println("Moving turn to Player W");
                    B_turn = !(B_turn);
                    flag = false;
                    continue;
                }
            }
            else{       // W's turn
                if(moves.W_avail){
                    System.out.println("Player White choose your move :");
                    int x = Integer.parseInt(s.next()) -1;
                    int y = (s.next()).charAt(0) - 'A';
                    Point ttry = new Point (x,y);
                    if(!(check_move(B_turn,ttry))){
                        System.out.println("Invalid move, try again");
                        flag = false;
                        continue;
                    }
                    else{
                        set_move(ttry, B_turn);
                        B_turn = ! B_turn;
                        flag = true;
                        continue;
                    }
                }
                else{
                    System.out.println("No legal moves for Player W");
                    System.out.println("Moving turn to Player B");
                    B_turn = !(B_turn);
                    flag = false;
                    continue;   
                }
            }        
        }

	}


}