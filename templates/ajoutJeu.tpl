{extends file='templates/accueil.tpl'}

{block name=customStyle}
<link rel="stylesheet" href="templates/assets/css/ajoutJeu.css" />
{/block}

{block name=headJS}
{/block}

{block name=barreRecherche}
{/block}

{block name=blocMain}
<main>
<form class="formulaireAdmin" method="POST" action="" enctype="multipart/form-data" onsubmit="return validernomJeu();">
    <div class="divConteneur">
        <div class="divPresentation customShadow marginBottom">
            <h1>Ce jeu n'éxiste pas dans la base de données</h1>
            <h2>Souhaitez-vous l'y ajouter?</h2>
        </div>

        <div id="divMessages" class="divPresentation customShadow marginBottom"></div>

        <div id="divNomJeu" class="bgColor customShadow marginBottom">
            <label for="nomJeu">Nom du jeu : </label>
            <input type="text" id="nomJeu" class="form-control" name="nomJeu" >
        </div>

        <div class="divExtraits marginBottom">
            <div class="divProduitAccueil customShadow">
                <label for="articleUnivers">Comment decririez-vous l'univers de ce jeu ?</label>
                <textarea id="articleUnivers" class="form-control" name="articleUnivers" ></textarea>
            </div>

            <div class="divProduitAccueil customShadow">
                <label for="articleFeeling">Que resentez-vous en jouant à ce jeu ?</label>
                <textarea id="articleFeeling" class="form-control" name="articleFeeling" ></textarea>
            </div>

            <div class="divProduitAccueil customShadow">
                <label for="articleInstant">Partagez avec nous un moment inoubliable !</label>
                <textarea id="articleInstant" class="form-control" name="articleInstant" ></textarea>
            </div>
        </div>

        <div class="divButton">
            <button type="submit" class="btn btn-primary" name="ajouterJeu">Ajouter</button>
        </div>
    </div>
</form>
</main>
{/block}

{block name=barreRechercheJS}
{/block}

{block name=postJS}
<script language="javascript">
    function validernomJeu()
    {
        console.log( 'test' );
        document.getElementById( 'divMessages' ).innerHTML = "";

        if ( document.getElementById( "nomJeu" ).value == "" )
        {
            document.getElementById( "nomJeu" ).classList.add( 'is-invalid' );
            document.getElementById( 'divMessages' ).innerHTML = 'Veuillez préciser un nom de jeu';
            return false;
        }
        else
        {
            document.getElementById( 'nomJeu' ).classList.remove( 'is-invalid' );
            document.getElementById( 'nomJeu' ).classList.add( 'is-valid' );
            var submit = false;
            
            if ( document.getElementById( 'articleUnivers').value != "" )
            {
                document.getElementById( 'articleUnivers').classList.remove( 'is-invalid' );
                document.getElementById( 'articleUnivers').classList.add( 'is-valid' );
                submit = true;
            }

            if ( document.getElementById( 'articleFeeling' ).value != "" )
            {
                document.getElementById( 'articleFeeling' ).classList.remove( 'is-invalid' );
                document.getElementById( 'articleFeeling' ).classList.add( 'is-valid' );
                submit = true;
            }

            if ( document.getElementById( 'articleInstant' ).value != "" )
            {
                document.getElementById( 'articleInstant' ).classList.remove( 'is-invalid' );
                document.getElementById( 'articleInstant' ).classList.add( 'is-valid' );
                submit = true;
            }

            if ( submit == false )
            {
                document.getElementById( 'articleUnivers').classList.add( 'is-invalid' );
                document.getElementById( 'articleFeeling' ).classList.add( 'is-invalid' );
                document.getElementById( 'articleInstant' ).classList.add( 'is-invalid' );

                document.getElementById( 'divMessages' ).innerHTML = 'Veuillez remplir au moins 1 de ces champs.';
            }

            return submit;
        }
    }
</script>
{/block}
