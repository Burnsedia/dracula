import { Link } from "gatsby"
import React, { useState} from "react"
import styled, { css } from "styled-components"

const Log = styled.div`
  background-color: #27ae60;
  margin: 0 0 2rem;
  padding: 1rem;
  text-align: center;
  width: 100vw;
  && h1 {
    margin: 0;
  }
  && li {
    font-size: 1.4rem;
    font-weight: bold;
    padding: 0.5rem;
  }
`
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

export default function BloodSugarLog() {
  const [bloodSugar, setBloodSugar] = useState("")
  const [bloodSugars, setBloodSugars] = useState([])

  const onSubmit = event => {
    event.preventDefault()
    if (bloodSugar !== "") {
      setBloodSugars([{ title: bloodSugar }, ...bloodSugars])
      setBloodSugar("")
    }
  }
  return (
    <Log>
     <form onSubmit={onSubmit}>
        <label htmlFor="bloodSugar">Log Blood Sugar</label>
        <input
          type="text"
          id="bloodSugar"
          value={bloodSugar}
          placeholder="Enter blood sugar here"
          onChange={event => {
            setBloodSugar(event.target.value)
          }}
        />
        <Button primary={bloodSugar === "" ? false : true} type="submit">
          Submit
        </Button>
      </form>
      <h2>Blood Sugar History</h2>
      <ul>
        {bloodSugars.map((bloodSugar, index) => {
          return <li key={`bloodSugar-${index}`}>{bloodSugar.title}</li>
        })}
      </ul>
    </Log>
  )
}

