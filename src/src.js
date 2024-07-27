import { fluentButton, fluentCard, fluentTextField, fluentSwitch, provideFluentDesignSystem } from '@fluentui/web-components'

provideFluentDesignSystem()
    .register(
        fluentButton(),
        fluentCard(),
        fluentTextField(),
        fluentSwitch()
    );

const shutdownButton = document.getElementById("shutdown")
shutdownButton.addEventListener("click", () => {  
    const inputToken = document.getElementById("token")
    const token = inputToken.value

    fetch('/shutdown', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        // リクエストボディにデータを追加
        body: JSON.stringify({ token: token }),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`)
        }
        return response.json();
    })
    .then(data => {
        if(data.status){
            alert("シャットダウンします")
            localStorage.setItem("shutdown-token", token)
        }else{
            alert("シャットダウンに失敗しました\nトークンが正しくありません")
        }
    })
    .catch(error => {
        console.error(error)
    });
})

const rebootButton = document.getElementById("reboot")
rebootButton.addEventListener("click", () => {  
    const inputToken = document.getElementById("token")
    const token = inputToken.value

    fetch('/reboot', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        // リクエストボディにデータを追加
        body: JSON.stringify({ token: token }),
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`)
        }
        return response.json();
    })
    .then(data => {
        if(data.status){
            alert("再起動します")
            localStorage.setItem("shutdown-token", token)
        }else{
            alert("再起動に失敗しました\nトークンが正しくありません")
        }
    })
    .catch(error => {
        console.error(error)
    });
})

const shutdownToken = localStorage.getItem("shutdown-token")
if(shutdownToken != null){
    const inputToken = document.getElementById("token")
    inputToken.value = shutdownToken
}


fetch('/get_token', {
    method: 'GET',
    headers: {
        'Content-Type': 'application/json',
    }
})
.then(response => {
    if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`)
    }
    return response.json();
})
.then(data => {
    if(data.status){
        const tokenInfo = document.getElementById("token-info")
        const tokenText = document.getElementById("token-text")
        tokenInfo.hidden = false
        const preElement = document.createElement('pre')
        preElement.id = "token-data"
        preElement.textContent = data.token
        tokenText.appendChild(preElement)
    }
})
.catch(error => {
    console.error(error)
});


fetch('/ip', {
    method: 'GET',
    headers: {
        'Content-Type': 'application/json',
    }
})
.then(response => {
    if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`)
    }
    return response.json();
})
.then(data => {
    const ipElement = document.getElementById("ip-addr")
    ipElement.textContent = `http://${data.ip}:50031/`
    ipElement.href = ipElement.textContent
})
.catch(error => {
    console.error(error)
});

const copyTokenButton = document.getElementById("copy-token")
copyTokenButton.addEventListener("click", () => {
    const tokenData = document.getElementById("token-data").textContent
    navigator.clipboard.writeText(tokenData).then(
        () => {
          alert("クリップボードへトークンをコピーしました")
        },
        () => {
          alert("クリップボードへのトークンのコピーが失敗しました")
        },
      );
})

const tokenVisible = document.getElementById("token-visible")
tokenVisible.addEventListener("change", () => {
    const inputToken = document.getElementById("token")
    const isOn = tokenVisible.checked
    if(isOn){
        inputToken.type = "text"
    }else{
        inputToken.type = "password"
    }
})