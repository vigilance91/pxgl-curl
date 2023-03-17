# [PXGL&trade;]() cURL BAT Library for WIN32 DOS CMD LINE

# Copyright &copy; Tyler R. Drury 16-03-2023, All Rights Reserved

## Proudly [Canadian](https://www.canada.ca/en.html), made in [Ontario](https://www.ontario.ca/).

Developed and maintained by Tyler R. Drury,

This back-end php project allows users of this web service to conveniently
download procedurally generated textures onto their local machines

---

## Use


### RGB Filled Textures
```
>_src\post\fill.bat --noig --w 32 --h 32 --r 255 --g 255 "%CD%/_output/y0"
```

### Greyscale Textures

```
>_src\post\greyscale\blackWhite.bat --noig --a row --w 32 --h 32 "%CD%/_output/bwRow32x32"
>_src\post\greyscale\whiteBlack.bat --noig --a col --w 32 --h 32 "%CD%/_output/wbCol32x32"
>_src\post\greyscale\fill.bat --noig --lum 32 --w 32 --h 32 "%CD%/_output/lum32"
>_src\post\greyscale\prbFill.bat --noig --w 32 --h 32 "%CD%/_output/prbFill"
```

### Square Textures

```
>_src\post\square\rand.bat --noig --s 32 "%CD%/_output/rndsqr"
>_src\post\square\fillGreyscale.bat --noig --s 32 --lum 64"%CD%/_output/lum64"
>_src\post\square\prbFill.bat --noig --s 32 "%CD%/_output/prbFil32x32"
>_src\post\square\prbFillGreyscale.bat --noig --s 32 "%CD%/_output/prbLum32x32"
```

### Default Values

Omitting 'w' or 'h' params in the following calls defaults to 64 pixels for the respective value

#### RGB Filled Textures

Omitting 'r', 'g' or 'b' params in this call defaults to  0 for the respective value

```
>_src\post\fill.bat --noig --r 255 "%CD%/_output/r0"
```

Will result in a solid red 64x64 texture being downloaded


#### Greyscale Textures

```
>_src\post\greyscale\blackWhite.bat --noig --a row "%CD%/_output/bwRow64x64"
>_src\post\greyscale\whiteBlack.bat --noig --a col "%CD%/_output/wbCol64x64"
>_src\post\greyscale\fill.bat --noig --lum 32 "%CD%/_output/lum32"
>_src\post\greyscale\prbFill.bat --noig "%CD%/_output/prbFill64x64"
```

Omitting 's' param in the following calls defaults to all output being 64x64 pixel PNGs


#### Square Textures

```
>_src\post\square\rand.bat --noig "%CD%/_output/rndsqr"
>_src\post\square\fillGreyscale.bat --noig --lum 64 "%CD%/_output/lum"
>_src\post\square\prbFill.bat --noig "%CD%/_output/lum"
>_src\post\square\prbFillGreyscale.bat --noig "%CD%/_output/lum"
```

---

## Download

Developers can clone the current, most stable, Source Code repo at [GitHub Repo](), if you wish to contribute.
    
---

## Primary Developer

* Tyler R. Drury

## Additional Contributors


---

## Additional References and Resources

* Official PXGL [Home page]()
* PHP 5.6 [RXGL PI]()


---