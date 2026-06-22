#include <stdio.h>

int main() {
    char *obrazki[] = {"blue.png", "orange.png", "toxic.png", "yellow.png"};
    int liczba_obrazkow = 4;

    printf("<!DOCTYPE html>\n<html>\n<head>\n  <style>\n");
    printf("    * {box-sizing: border-box; font-family: sans-serif;}\n");
    printf("    .responsive {padding: 0 6px; float: left; width: 24.99999%%;}\n");
    printf("    .clearfix:after {content: \"\"; display: table; clear: both;}\n");
    printf("    @media only screen and (max-width: 700px) {.responsive {width: 49.99999%%; margin: 5px 0;}}\n");
    printf("    @media only screen and (max-width: 500px) {.responsive {width: 100%%; }}\n");
    printf("    div.gallery {border: 1px solid #ccc;}\n");
    printf("    div.gallery:hover {border: 1px solid #777;}\n");
    printf("    div.gallery img {width: 100%%; height: auto;}\n");
    printf("    div.desc {padding: 15px; text-align: center;}\n");
    printf("  </style>\n  <title>Dumb Image Gallery</title>\n</head>\n<body>\n");
    printf("<h2>Dumb Image Gallery</h2>\n<h4>Foo Bar GraphiC DesigneR</h4>\n\n");

    for(int i = 0; i < liczba_obrazkow; i++) {
        printf("\n", i + 1, obrazki[i]);
        printf("<div class=\"responsive\">\n");
        printf("  <div class=\"gallery\">\n");
        printf("    <a target=\"_blank\" href=\"%s\">\n", obrazki[i]);
        printf("      <img src=\"%s\">\n", obrazki[i]);
        printf("    </a>\n");
        printf("    <div class=\"desc\">%s</div>\n", obrazki[i]);
        printf("  </div>\n");
        printf("</div>\n\n");
    }

    printf("<div class=\"clearfix\"></div>\n</body>\n</html>\n");
    return 0;
}
