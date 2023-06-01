{extends file='templates/accueil.tpl'}

{block name=customStyle}
<link rel="stylesheet" href="templates/assets/css/pageProduit.css" />
{/block}

{block name=blocMain}
<main>
    <div id="divConteneur">
        <div id="divZoneAjout" onclick="cacherFormulaireAjout()">
        </div>

        {* formulaire d'ajout article *}
        <div id="divAjoutArticle" class="divAjout customShadow">

            <h3>Ajouter un article</h3>
            <textarea name="texteArticle" id="texteArticle" placeholder="Article"></textarea>
                
            <button class="btn btn-primary" id="submitTexteArticle" onclick="submitAjoutArticle()">Valider</button>
        </div>

        {* formulaire d'ajout image *}
        <div id="divAjoutImage" class="divAjout customShadow">
            <h3>Ajouter une image</h3>
            <form method="post" id="formImage" enctype="multipart/form-data" action="ajaxAjoutImage.php" onsubmit="AJAXSubmit( this ); return false;">
                <label for="mon_fichier">Fichier (.jpeg, .jpg | max. 10 Mo) :</label>
                <input type="hidden" name="titreProduit" value="{$titreProduit}">
                <input type="hidden" id="MAX_FILE_SIZE" name="MAX_FILE_SIZE" value="10485760" />
                <p><input type="file" id="imageJeu" name="imageJeu" /></p>
                
                <button id="formImageButton" type="submit" class="btn btn-primary">Valider</button>
            </form>
        </div>
        
        {* afficher les images *}
        {if !empty($tabImages)}
        <button id="buttonAddImage" class="btn btn-primary" onclick="appellerFormulaireAjoutImage()">Ajouter une image</button>
        <div id="carouselImagesProduits" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#carouselImagesProduits" data-slide-to="0" class="active"></li>
                {for $i=1 to $tabImages|@count-1}
                    <li data-target="#carouselImagesProduits" data-slide-to={$i}></li>
                {/for}
            </ol>

            <div class="carousel-inner" style="height:350px;">
                {foreach from=$tabImages item=image name=tab}
                    {if $smarty.foreach.tab.first}
                        <div class="carousel-item active">
                    {else}
                        <div class="carousel-item">
                    {/if}
                        <div class="carouselConteneur">
                            <img src="{$link->getUrlImagejeuRedim($image->getNomImage())}" class="d-block" alt="...">
                        </div>
                    </div>
                {/foreach}
            </div>

            <a class="carousel-control-prev" href="#carouselImagesProduits" role="button" data-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>

            <a class="carousel-control-next" href="#carouselImagesProduits" role="button" data-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
        </div>
        {else}
        <button id="buttonAddImage" class="btn btn-primary" onclick="appellerFormulaireAjoutImage( {$idProduit} )">Ajouter une image</button>
        {/if}

        {* titre du produit *}
        <div class="divPresentation customShadow">
            <h2>{$titreProduit}</h2>
        </div>

        {* section des articles *}
        <div class="divExtraits">
            {foreach from=$tabArticles item=article key=categorie name=tab}
                <div class="divArticleProduit customShadow">
                    <div class="divProduit">
                        <h3>{$categorie}</h3>
                        {if !empty($article->getTexte())}
                        <p>{$article->getTexte()}</p>
                        {else}
                        <p>{$messageArticleVide}</p>
                        {/if}
                        {* affichage des boutons "commentaires" et "ajouter articles" *}
                        <div class="divButtons">
                            {if !empty($article->getTexte())}
                            <button class="btn btn-primary" id="buttonComment{$smarty.foreach.tab.index}" onclick="switchDivCommentaire( {$smarty.foreach.tab.index} )">Commentaires</button>
                            {/if}
                            <button class="btn btn-primary" onclick='appellerFormulaireAjoutArticle( {$idProduit}, {$smarty.foreach.tab.iteration}, "{$tabIntrosAjoutArticle[$smarty.foreach.tab.index]}" )'>Ajouter un article</button>
                        </div>
                    </div>
                    <div id="divComment{$smarty.foreach.tab.index}" class="divCommentaires" style="display: none;">
                        {* formulaire pour ajout de commentaires *}
                        <hr />
                        <div id="divAjoutCommentaires">
                            <textarea id="texteCommentaire{$smarty.foreach.tab.index}" placeholder="Ajouter un commentaire"></textarea>

                            <button class="btn btn-primary" onclick="submitAjoutCommentaire( {$article->getIdArticle()}, 'texteCommentaire{$smarty.foreach.tab.index}' )">Valider</button>
                        </div>
                        <hr />

                        {if isset($tabCommentairesArticles) && !empty($tabCommentairesArticles[$smarty.foreach.tab.index])}
                            {foreach from=$tabCommentairesArticles[$smarty.foreach.tab.index] item=commentaire}
                                <p>{$commentaire->getTexte()}</p>
                                <hr />
                            {/foreach}
                        {/if}
                    </div>
                </div>
            {/foreach}
        </div>
    </div>
</main>
{/block}

{block name=postJS}
<script>
    // afficher les commentaires ==============================================

    var tabDivCommentaires = [];

    for ( i = 0; i != document.getElementsByClassName( "divCommentaires" ).length; ++i )
    {
        tabDivCommentaires.push( document.getElementsByClassName( "divCommentaires" )[i] );
    }

    function switchDivCommentaire( index )
    {
        if ( tabDivCommentaires[index].style.display == "none" )
        {
            tabDivCommentaires[index].style.display = "block";
        }
        else
        {
            tabDivCommentaires[index].style.display = "none";
        }
    }

    // ajout commentaires =====================================================

    var texteCommentaire;
    var idArticle;

    function submitAjoutCommentaire( idArticle, element )
    {
        this.idArticle = idArticle;
        this.texteCommentaire = document.getElementById( element ).value;

        // console.log( idArticle );
        // console.log( texteCommentaire );
        // console.log( element );

        if ( this.texteCommentaire == "" )
        {
            alert( 'Veuillez entrer un commentaire' );
        }
        else
        {
            ajaxAjoutCommentaire( element );
        }
    }

    function ajaxAjoutCommentaire( element )
    {
        var xhr=null;
        
        if (window.XMLHttpRequest) 
        { 
            xhr = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) 
        {
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
        }

        //on définit l'appel de la fonction au retour serveur
        xhr.onreadystatechange = function() { alertAjaxAjoutCommentaire( xhr, element ); };

        xhr.open( "POST", "././ajaxAjoutCommentaire.php", true );
        // on définit les bonnes propriétés d'en-tête avec la requète
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.send( "texteCommentaire="+texteCommentaire+"&idArticle="+idArticle );
    }

    function alertAjaxAjoutCommentaire( xhr, element )
    {
        if ( xhr.readyState == 4 && xhr.status == 200 )
        {
            alert( "Commentaire ajouté avec succés." );

            // vider le textarea de son contenu
            document.getElementById( element ).value = "";
        }
    }

    // ajout articles =========================================================

    var texteArticle;
    var idProduit;
    var idCategorie;
    var introArticle;

    function submitAjoutArticle() 
    {
        texteArticle = document.getElementById( 'texteArticle' ).value;

        if ( texteArticle == "" ) 
        {
            alert( "Veuillez entrer un article." );
        } 
        else 
        {
            ajaxAjoutArticle();
            cacherFormulaireAjout();
            alert( "Article ajouté avec succés.");
        }
    }

    function appellerFormulaireAjoutArticle( idProduit, idCategorie, introArticle )
    {
        this.idProduit = idProduit;
        this.idCategorie = idCategorie;
        this.introArticle = introArticle;

        // console.log( idProduit );
        // console.log( idCategorie );
        // console.log( introArticle );

        document.getElementById( 'divZoneAjout' ).style.display = "block";
        document.getElementById( 'divAjoutArticle' ).style.display = "grid";
        document.getElementById( 'texteArticle' ).setAttribute( "placeholder", introArticle );
    }

    function cacherFormulaireAjout()
    {
        document.getElementById( 'divZoneAjout' ).style.display = "none";

        document.getElementById( 'divAjoutArticle' ).style.display = "none";
        document.getElementById( 'divAjoutImage' ).style.display = "none";

        document.getElementById( 'texteArticle').value = "";
    }



    function ajaxAjoutArticle()
    {
        var xhr=null;
        
        if (window.XMLHttpRequest) 
        { 
            xhr = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) 
        {
            xhr = new ActiveXObject("Microsoft.XMLHTTP");
        }

        //on définit l'appel de la fonction au retour serveur
        // xhr.onreadystatechange = function() { ajaxAlertAjoutArticle( xhr ); };

        xhr.open( "POST", "././ajaxAjoutArticle.php", true );
        // on définit les bonnes propriétés d'en-tête avec la requète        
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.send( "texteArticle="+texteArticle+"&idProduit="+idProduit+"&idCategorie="+idCategorie );
    }

    function ajaxAlertAjoutArticle( xhr )
    {
        if ( xhr.readyState == 4 && xhr.status == 200 )
        {
            alert( "Article ajouté avec succés." );
        }
    }

    // ajouter images =========================================================

    var formImage = document.getElementById( "formImage" );
    var imageJeuFile = document.getElementById( "imageJeu" );
    var formImageButton = document.getElementById( "formImageButton" );

    function appellerFormulaireAjoutImage()
    {
        document.getElementById( 'divZoneAjout' ).style.display = "block";
        document.getElementById( 'divAjoutImage' ).style.display = "grid";
    }

    // ========================================================================

    function ajaxSuccess() 
    {
        // console.log( this.responseText );
        alert( 'Image ajoutée avec succés' );
    }

    function AJAXSubmit( oFormElement ) 
    {
        var imgPath = document.getElementById( 'imageJeu' ).value;
        if ( !oFormElement.action || imgPath == "" ) 
        { 
            alert( 'Veuillez selectionner une image' );
            return; 
        }
        else
        {
            var extension = imgPath.substring( imgPath.lastIndexOf( "." ) );
            if ( extension != ".jpg" && extension != ".jpeg" )
            {
                alert( "Le format de l'image n'est pas valide\nLes formats valides sont :\u000a      .jpg\n      .jpeg" );
                return;
            }
            else
            {
                let maxFileSize = document.getElementById( "MAX_FILE_SIZE" ).value;
                if ( oFormElement.elements[2].files[0].size > maxFileSize )
                {
                    alert( "Cette image est trop volumineuse" );
                }
            }
        }

        var oReq = new XMLHttpRequest();
        oReq.onload = ajaxSuccess;

        if ( oFormElement.method.toLowerCase() === "post" )
        {
            oReq.open( "post", oFormElement.action );
            oReq.send( new FormData( oFormElement ) );
        } 
        else 
        {
            var oField, sFieldType, nFile, sSearch = "";
            for ( var nItem = 0; nItem < oFormElement.elements.length; nItem++ ) 
            {
                oField = oFormElement.elements[nItem];
                if ( !oField.hasAttribute( "name" ) ) 
                { 
                    continue; 
                }

                sFieldType = oField.nodeName.toUpperCase() === "INPUT" ?
                    oField.getAttribute("type").toUpperCase() : "TEXT";

                if ( sFieldType === "FILE" )
                {
                    for ( nFile = 0; nFile < oField.files.length; sSearch += "&" + escape( oField.name ) + "=" + escape( oField.files[nFile++].name ) );
                } 
                else if ( ( sFieldType !== "RADIO" && sFieldType !== "CHECKBOX" ) || oField.checked ) 
                {
                    sSearch += "&" + escape( oField.name ) + "=" + escape( oField.value );
                }
            }

            oReq.open( "get", oFormElement.action.replace( /(?:\?.*)?$/, sSearch.replace( /^&/, "?" ) ), true );
            oReq.send( null );
        }

        cacherFormulaireAjout();
    }
</script>
{/block}
