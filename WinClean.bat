
@echo off
setlocal EnableExtensions
title Windows Cleaner - Manutencao do Sistema
color 0A

:: ============================================================
:: Windows Cleaner
:: Automatizacao de tarefas basicas de manutencao do Windows
:: Uso autorizado em ambientes Windows 10 e Windows 11
:: ============================================================

:: Verificar privilegios administrativos
net session >nul 2>&1
if errorlevel 1 (
    echo.
    echo [INFO] Esta operacao requer privilegios administrativos.
    echo [INFO] Solicitando elevacao de privilegios...
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Configurar registro de execucao
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"

set "LOGDIR=%~dp0Logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%" >nul 2>&1
set "LOGFILE=%LOGDIR%\WindowsCleaner_%COMPUTERNAME%_%STAMP%.log"

:: Registrar espaco livre inicial
set "SPACE_BEFORE="
for /f %%I in ('powershell -NoProfile -Command "[System.IO.DriveInfo]::new($env:SystemDrive).AvailableFreeSpace"') do set "SPACE_BEFORE=%%I"

cls
echo.
echo ============================================================
echo                    WINDOWS CLEANER
echo             SISTEMA DE MANUTENCAO DO WINDOWS
echo ============================================================
echo.
echo Computador : %COMPUTERNAME%
echo Usuario    : %USERNAME%
echo Unidade    : %SystemDrive%
echo Inicio     : %DATE% %TIME%
echo.
echo [INFO] Inicializando procedimentos de manutencao...
echo.

call :log "Inicio da manutencao."
call :log "Computador: %COMPUTERNAME% - Usuario: %USERNAME%"

:: 01 - Temporarios do usuario
echo [01/06] Limpando arquivos temporarios do usuario...
call :log "Limpando temporarios do usuario."
if defined TEMP (
    if exist "%TEMP%\" (
        del /f /s /q "%TEMP%\*" >nul 2>&1
        for /d %%D in ("%TEMP%\*") do (
            if exist "%%~fD\" rd /s /q "%%~fD" >nul 2>&1
        )
    )
)
echo         Procedimento concluido.
echo.

:: 02 - Temporarios do Windows
echo [02/06] Limpando arquivos temporarios do Windows...
call :log "Limpando temporarios do Windows."
if exist "%SystemRoot%\Temp\" (
    del /f /s /q "%SystemRoot%\Temp\*" >nul 2>&1
    for /d %%D in ("%SystemRoot%\Temp\*") do (
        if exist "%%~fD\" rd /s /q "%%~fD" >nul 2>&1
    )
)
echo         Procedimento concluido.
echo.

:: 03 - Cache de miniaturas
echo [03/06] Limpando cache de miniaturas...
call :log "Limpando cache de miniaturas."
if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer\" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
echo         Procedimento concluido.
echo.

:: 04 - Cache de shaders
echo [04/06] Limpando caches graficos conhecidos...
call :log "Limpando caches graficos."
for %%D in (
    "%LOCALAPPDATA%\D3DSCache"
    "%LOCALAPPDATA%\NVIDIA\DXCache"
    "%LOCALAPPDATA%\NVIDIA\GLCache"
) do (
    if exist "%%~D\" (
        del /f /s /q "%%~D\*" >nul 2>&1
        for /d %%S in ("%%~D\*") do (
            if exist "%%~fS\" rd /s /q "%%~fS" >nul 2>&1
        )
    )
)
echo         Procedimento concluido.
echo.

:: 05 - Lixeira (opcional)
echo [05/06] Limpeza da Lixeira
echo.
echo ATENCAO: esta acao remove permanentemente os itens
echo presentes na Lixeira e pode afetar arquivos de trabalho.
choice /c SN /n /m "Deseja esvaziar a Lixeira? [S/N]: "

if errorlevel 2 (
    echo         Operacao ignorada pelo usuario.
    call :log "Lixeira preservada por escolha do usuario."
) else (
    echo         Processando...
    powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
    if errorlevel 1 (
        echo         Nao foi possivel concluir a operacao.
        call :log "Aviso: nao foi possivel confirmar a limpeza da Lixeira."
    ) else (
        echo         Solicitao de limpeza enviada.
        call :log "Solicitacao de limpeza da Lixeira executada."
    )
)
echo.

:: 06 - Relatorio de armazenamento
echo [06/06] Verificando armazenamento...
set "SPACE_AFTER="
for /f %%I in ('powershell -NoProfile -Command "[System.IO.DriveInfo]::new($env:SystemDrive).AvailableFreeSpace"') do set "SPACE_AFTER=%%I"

if defined SPACE_AFTER (
    powershell -NoProfile -Command ^
      "$b=[long]'%SPACE_BEFORE%'; $a=[long]'%SPACE_AFTER%';" ^
      "Write-Host ('        Espaco livre antes : {0:N2} GB' -f ($b/1GB));" ^
      "Write-Host ('        Espaco livre depois: {0:N2} GB' -f ($a/1GB));" ^
      "Write-Host ('        Variacao de espaco : {0:N2} GB' -f (($a-$b)/1GB))"
    call :log "Verificacao de espaco livre concluida."
) else (
    echo         Nao foi possivel obter os dados da unidade.
    call :log "Aviso: falha ao consultar o armazenamento."
)

echo.
echo ============================================================
echo                  PROCESSO FINALIZADO
echo ============================================================
echo.
echo [INFO] Arquivos em uso ou protegidos podem ter sido ignorados.
echo [INFO] A variacao de espaco inclui outras alteracoes no disco.
echo [INFO] O registro de execucao fica na pasta Logs.
echo.
call :log "Fim da manutencao."

echo Pressione qualquer tecla para encerrar.
pause >nul
endlocal
exit /b

:log
>>"%LOGFILE%" echo [%DATE% %TIME%] %~1
exit /b
