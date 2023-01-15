import { createGlobalStyle } from "styled-components"

export const GlobalStyles = createGlobalStyle`
    *{box-sizing: border-box}
    body {
        background-color: #282a36;
        margin: 0;
        padding: 0;
        font-family: Arial, Helvetica, sans-serif;
    };
    ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
    }
`
