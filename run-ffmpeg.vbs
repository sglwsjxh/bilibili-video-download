' run-ffmpeg.vbs
' 用途：通过自定义协议 ffmpeg-run:// 接收命令并在新终端中执行
' 用法：ffmpeg-run://<URL编码的命令>

Dim args, rawUrl, cmdPart, decodedCmd, shell
Set args = WScript.Arguments

If args.Count = 0 Then
    WScript.Quit 1
End If

' 获取传入的完整URL（例如 ffmpeg-run://ffmpeg%20-i...）
rawUrl = args(0)

' 提取协议后的部分（去掉 "ffmpeg-run://"）
cmdPart = Mid(rawUrl, Len("ffmpeg-run://") + 1)

' URL解码
decodedCmd = DecodeUrl(cmdPart)

' 在新窗口中打开cmd，执行命令（/k 保持窗口打开）
Set shell = CreateObject("WScript.Shell")
shell.Run "cmd /k " & decodedCmd, 1, False

' 辅助函数：URL解码
Function DecodeUrl(str)
    Dim i, c, ret
    ret = ""
    For i = 1 To Len(str)
        c = Mid(str, i, 1)
        If c = "%" And i + 2 <= Len(str) Then
            ret = ret & Chr(CLng("&H" & Mid(str, i + 1, 2)))
            i = i + 2
        Else
            ret = ret & c
        End If
    Next
    DecodeUrl = ret
End Function