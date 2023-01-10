import React, { useState} from "react"
import styled, { css } from "styled-components"
import Navbar from "../components/Navbar"
import BloodSugarLog from "../components/BloodSugarLog"


// const Button = styled.button`
//   background: transparent;
//   border-radius: 5px;
//   border: 2px solid red;
//   color: red;
//   margin: 0 1em;
//   padding: 0.25em 1em;
//   transition: all ease 100ms;
//   &&:hover {
//     cursor: pointer;
//     color: white;
//     background-color: palevioletred;
//   }
//   ${props =>
//     props.primary &&
//     css`
//       background: palevioletred;
//       color: white;
//     `};
// `
const Container = styled.div`
  text-align: center;
`

function App() {
  

  return (
    <Container className="App">
      <Navbar />
      <BloodSugarLog />
    </Container>
  )
}

export default App
