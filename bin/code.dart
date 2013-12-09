
import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';

main() {
  var countW = 50;
  var countR = countW/2;
  var xoffset = 20, yoffset = 20;
  var xpos = 0, ypos = 0;
  var theCanvas = document.getElementById('canvas');
  var context = theCanvas.getContext('2d');
  var canW = document.getElementById('canvas').clientWidth;
  var playerColor = '';
  var player = 1;
  var pos,gridpos,won,duringDrop = false;
  var myGrid = new List(7);
    for (var i = 0; i < 7; i++) {
    myGrid[i] = [0,0,0,0,0,0];
  }
    clear() {
      context.clearRect(0, yoffset,canW,countW);
  }
    checkGrid() {
//if all grid full and no match then draw!
      var temp = '';
      for(var i = 0; i <= 6; i++) //check vertical counters
      {
        temp = myGrid[i].join();
        if (temp.lastIndexOf(player+','+player+','+player+','+player) > 0) won = true;
      }

      temp = '';

      for (var j = 0 ; j < 6; j++) //check horizontal counters
        for (var i = 0; i < 7; i++)
        {
          if ((i % 7) == 0) temp += '\r\n';
          temp += myGrid[i][j];
        }
      if (temp.lastIndexOf(player+''+player+''+player+''+player) > -1) won = true;

      temp = '';


      for (var i = 1; i <= 4; i++) //check diagonal counters
        temp += myGrid[i-1][i+1];

      temp += '\r\n';

      for (var i = 1; i <= 4; i++)
        temp += myGrid[i+2][i-1];

      temp += '\r\n';

      for (var i = 1; i <= 5; i++)
        temp += myGrid[i-1][i];

      temp = temp + '\r\n';

      for (var i = 1; i <= 6; i++)
        temp += myGrid[i-1][i-1];

      temp += '\r\n';

      for (var i = 1; i <= 6; i++)
        temp += myGrid[i][i-1];

      temp += '\r\n';

      for (var i = 1; i <= 5; i++)
        temp += myGrid[i+1][i-1];

      temp += '\r\n';

      for (var i = 0; i <= 3; i++)
        temp += myGrid[i][(i-3).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 4; i++)
        temp += myGrid[i][(i-3).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 4; i++)
        temp += myGrid[i][(i-4).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 5; i++)
        temp += myGrid[i][(i-5).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 5; i++)
        temp += myGrid[i+1][(i-5).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 4; i++)
        temp += myGrid[i+2][(i-5).abs()];

      temp += '\r\n';

      for (var i = 0; i <= 3; i++)
        temp += myGrid[i+3][(i-5).abs()];

      if (temp.search(player + '' + player + '' + player + '' + player) > - 1) won = true;


      if (won)
      {
        window.alert('Player '+ player +' won');
        myGrid();
      }
    }
    getColor(){
      player == 1 ? playerColor = '#FF0000':playerColor = '#7CFC00';
    }
    dropCounter(){
//if column full, don't just move to next players turn
//create counter function with color/radius parameter or a circle function
      getColor();
      if (xpos > xoffset+countR && xpos < (countR+countW*7)-(xoffset))
      {
        if (gridpos == 0 && pos == 0) gridpos = (((xpos - xoffset /7)/50).round()-1);

        if (gridpos > -1 && gridpos < 7)
        {
          duringDrop = true;
          clear();
          if (pos > 0)
          {
            context.fillStyle = 'white';
            context.beginPath();
            context.arc(countR+gridpos*countW+xoffset,((countR+50)+(pos*50)-50+yoffset)-countW,countR-5,0,Math.PI*2,true);
            context.closePath();
            context.fill();
          }

          context.fillStyle = playerColor;
          context.beginPath();
          context.arc(countR + gridpos * countW + xoffset,(countR + 50) + (pos * 50) - 50 + yoffset,countR - 5,0,Math.PI*2,true);
          context.closePath();
          context.fill();
          context.stroke();

          context.beginPath();
          context.arc(countR + gridpos * countW + xoffset,(countR + 50) + (pos * 50) - 50 + yoffset,countR - 13,0,Math.PI*2,true);
          context.closePath();
          context.fill();
          context.stroke();

          pos++;

          if ((pos != 7 && myGrid[gridpos][pos-1] < 1))
            var dropTicker = new Timer(new Duration(milliseconds:50),dropCounter());
          else
          {
            pos-=2;
            if (myGrid[gridpos][pos] == 0) myGrid[gridpos][pos] = player;
            var dropTicker = new Timer(new Duration(milliseconds:50),dropCounter());
            dropTicker.cancel;
            checkGrid();
            if (!won && myGrid[gridpos][pos] == player)
              player == 1 ? player++:player = 1;
            pos = 0; gridpos = 0;
            duringDrop = false;
          }
        }
      }
    }

    drawCounter(e) {
      if (!duringDrop) {
        getColor();
        xpos = e.pageX;
        ypos = e.pageY;
        context.fillStyle = "rgba(255,255,255,1)";
        context.fillRect(10,401,200,200);
        context.stroke();
        context.fillStyle = "rgba(0,0,0,1)";
        context.font = "bold 16px Garamond";
        context.fillText('Player '+player, 10, 416);

        if (e.pageX > xoffset+countR+10 && e.pageX < (countR+countW*7)-(xoffset))
        {
          clear();
          context.fillStyle = playerColor;
          context.beginPath();
          context.arc(e.pageX-10,(countR)+yoffset,countR-5,0,Math.PI*2,true);
          context.closePath();
          context.fill();
          context.stroke();

          context.beginPath();
          context.arc(e.pageX-10,(countR)+yoffset,countR-13,0,Math.PI*2,true);
          context.closePath();
          context.fill();
          context.stroke();
        }
      }
    }
    showGrid() {
      var mytest = '';

      for (var j = 0; j < 6; j++)
        for (var i = 0; i < 7; i++)
        {
          if ((i % 7) == 0) mytest += '\r\n';
          mytest += myGrid[i][j];
        }
      window.alert(mytest);
    }

    clearGrid() {
      for (var j = 0; j < 6; j++)
        for (var i = 0; i < 7; i++)
          myGrid[i][j] = 0;
    }

    initGrid() {
      won = false;
      gridpos = 0; pos = 0;
      clearGrid();
      context.fillStyle = "rgba(0,0,0,1)";
      context.font = "bold 20px Garamond";
      context.fillText("Connect 4", 10, 20);

      for (var j = 1; j <= 6; j++)
        for (var i = 0; i < 7; i++)
        {
          context.fillStyle = "rgba(0,0,255,1)";
          context.fillRect(0+i*countW+xoffset,countW*j+yoffset,countW,countW);
          context.strokeRect(0+i*countW+xoffset,countW*j+yoffset,countW,countW);
          context.fillStyle = "rgba(255,255,255,1)";
          context.beginPath();
          context.arc(countR+i*countW+xoffset,(countR+50)+(j*50)-50+yoffset,countR-5,0,Math.PI*2,true);
          context.closePath();
          context.fill();
          context.stroke();
        }
      context.fillStyle = "rgba(0,0,255,1)";
      context.fillRect(xoffset-8,countW*7+yoffset,countW*7+16,20);
      context.strokeRect(xoffset-8,countW*7+yoffset,countW*7+16,20);

      document.onMouseMove;
        drawCounter;

      document.onClick;
      dropCounter;
    }

    window.onLoad;
    initGrid;
}