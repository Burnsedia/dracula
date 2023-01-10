import React, { useState} from "react"
import styled, { css } from "styled-components"
import Navbar from "../components/Navbar"


const Button = styled.button`
  background: transparent;
  border-radius: 5px;
  border: 2px solid red;
  color: red;
  margin: 0 1em;
  padding: 0.25em 1em;
  transition: all ease 100ms;
  &&:hover {
    cursor: pointer;
    color: white;
    background-color: palevioletred;
  }
  ${props =>
    props.primary &&
    css`
      background: palevioletred;
      color: white;
    `};
`
const Container = styled.div`
  text-align: center;
`

function App() {
  const [todo, setTodo] = useState("")
  const [todos, setTodos] = useState([])

  const onSubmit = event => {
    event.preventDefault()
    if (todo !== "") {
      setTodos([{ title: todo }, ...todos])
      setTodo("")
    }
  }

  return (
    <Container className="App">
      <Navbar />
      <form onSubmit={onSubmit}>
        <label htmlFor="todo">Add to do</label>
        <input
          type="text"
          id="todo"
          value={todo}
          placeholder="Enter Todo here"
          onChange={event => {
            setTodo(event.target.value)
          }}
        />

        <Button primary={todo === "" ? false : true} type="submit">
          Submit
        </Button>
      </form>
      <h2>Todo List</h2>
      <ul>
        {todos.map((todo, index) => {
          return <li key={`todo-${index}`}>{todo.title}</li>
        })}
      </ul>
    </Container>
  )
}

export default App
