# BrainFK Interpreter

An interpreter created for the BrainFK language.

BrainFK is a language known for its simplicity to write an interpretor for but its difficulty to actually program in.

## Running the Project

This program is built using the Zig programming language and uses most of the default project setup.

As a result, you will need to have the latest build of zig installed on your system to use this.

To build the project, simply run 
```
zig build
```

This will create the interpretor executable at `./zig-out/bin/brain`. The interpretor can then be used on a file of your choice by providing the file as a command line argument as shown below:
```
./zig-out/bin/brain examples/helloworld.bf
```

## Additional Notes

This is my first project written in the Zig programming language and is just intended as a way for me to learn the language - this is not meant as a full feature rich interpretor.

This is also my first attempt at creating an interpretor, so there may be much better ways to approach this problem then the one I have taken, but again this is just an educational project for the time being
