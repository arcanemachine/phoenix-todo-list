/* data */
export const data = [
  {
    name: "todosLive",
    data: todosLive,
  },
];

// data - functions
function todosLive() {
  return {
    hello: "world",

    init() {
      console.log("todosLive alpine component is working!");
    },
  };
}
