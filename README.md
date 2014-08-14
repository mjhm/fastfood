
## The Original Async Restaurant

This is a project to demonstrate some simple asynchronous programming in Node.  Four approaches are demonstrated:


1. Basic Node Callback
1. Bluebird Promise Library
1. Q Promise Library
1. Async Library (In Progress)

#### Instructions

1. Install Node and coffee-script.
2. Clone this repository locally.
3. "cd" into the cloned repository.
4. Install the dependencies with "npm install"
5. Run the tests "npm start"
6. Point your browser to localhost:3000
7. Select a async style.

All of the different approaches have identical functionality.  You check off menu items and make an order. The output is a JSON representation of the order (or an "Out of Bacon" error if you checked "bacon").  There is some built in cooking time for burgers and fries.

The main asynchronouse work is being done in the services/*_order.coffee files. Use NodeInspector or print statements to trace the execution.
