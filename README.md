### Hogyan használjuk elsőre?
1. Átnevezed az ```.env.example``` fájlt ```.env```-re.
2. Beállítod, hogy az otthoni MySQL szerveredre csatlakozzon.
3. Telepíted a függőségeket. ```npm i``` és ```composer install```
4. Generálsz magadnak kulcsot ```php artisan key:generate```
5. MySQL migrációt futtatsz. ```php artisan migrate```
6. Elindítod a szervert. ```composer run dev```

### Docker használata
1. Opcionálisan átnevezed az ```.env.docker.example``` fájlt ```.env.docker```-re.
2. Fejlesztői környezet indítása: ```docker-compose -f docker-compose.dev.yml up --build```
3. Prod környezet indítása: ```docker-compose up --build```

A Docker változókat így állíthatod be:
- terminalban: ```APP_PORT=9000 docker-compose -f docker-compose.dev.yml up```
- ```.env.docker``` fájlban