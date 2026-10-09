git <- function(args) {
  status <- system2("git", args)
  if (status != 0) stop("Falha no Git; confira a mensagem acima.")
}

# Executa a renderização e espera que termine.
quarto::quarto_render(as_job = FALSE)

# Inclui o fonte e a página gerada.
git(c("add", "--", "index.qmd", "_quarto.yml", "docs", "publish.R"))

# Cria um commit somente quando existem alterações.
alteracoes <- system2("git", c("diff", "--cached", "--quiet"))

if (alteracoes == 1) {
  mensagem <- paste("Atualiza painel", Sys.time())
  git(c("commit", "-m", shQuote(mensagem)))
} else if (alteracoes != 0) {
  stop("Não foi possível verificar as alterações.")
}

git("push")
message("Enviado ao GitHub. Aguarde a atualização do Pages.")