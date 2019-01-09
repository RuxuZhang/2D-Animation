void showHelpScreen()
    {
    background(yellow); // paints background in yellow
    image(FaceStudent1, width-150,0,150,150.*FaceStudent1.height/FaceStudent1.width); // displays picture of student
    image(FaceStudent2, width-150,150.*FaceStudent1.height/FaceStudent1.width,150,150.*FaceStudent2.height/FaceStudent2.width); // displays picture of other student in team
    textAlign(LEFT, TOP);
    fill(black); // color for writing on screen (notice : writing text uses fill not stroke to define the color)
    int L=0; // line counter, incremented below for ech line
    writeLine("CLASS: CS6491 Fall 2018",L++); //*G use this in stead of the above line
    writeLine("PROJECT 1: Morphing Quads",L++); //*G use this in stead of the above line
    //*******by Ruxu Zhang*******
    writeLine("STUDENT: Ruxu Zhang",L++); //** Put your name here
    writeLine("PARTNER: Jiahui Lu",L++); //** Put your team partner's name here
    writeLine("MENU <SPACE>:hide/show",L++);
    writeLine("POINTS click&drag:closest, x:moveAll, z:zoomAll,",L++);
    writeLine("POINTS ]:square, /:align r:read, w:write",L++);
    writeLine("DISPLAY f:fill, #:Point IDs, v:arrows",L++);
    writeLine("ANIMATION a:on/off, ,/.:speedControl",L++);
    writeLine("EDGE MORPH l:LERP, s:LPM",L++);
    writeLine("FILENAME FN C:set to content of clipboard",L++);
    writeLine("CAPTURE CANVAS to FN ~:pdf, !:jpg, @:tif, `:filming restart/stop",L++);
    writeLine("4 QUADS: 4:squares, R:read(FN), W:write(FN), f:fill, t:texture, g:register, n:smoothening by Neville",L++);
    writeLine("MESH: m:mesh mode, -:decrease grids, =:increase grids, c:SQUINT/Coon's Patch/both",L++);
    }
