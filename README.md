### Hogyan használjuk elsőre?
1. Átnevezed az ```.env.example``` fájlt ```.env```-re.
2. Beállítod, hogy az otthoni MySQL szerveredre csatlakozzon.
3. Telepíted a függőségeket. ```npm i``` és ```composer install```
4. Generálsz magadnak kulcsot ```php artisan key:generate```
5. MySQL migrációt futtatsz. ```php artisan migrate```
6. Elindítod a szervert. ```composer run dev```