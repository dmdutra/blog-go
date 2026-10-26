# Blog Dutra

Blog estático gerado com Hugo.

## Container local

```bash
docker build -t blog-dutra .
docker run --rm -p 8080:80 blog-dutra
```

Acesse http://localhost:8080. O Dockerfile gera o site com Hugo e serve os
arquivos estáticos com Nginx, incluindo a página de erro 404.

## Publicação no GitHub Container Registry

O workflow `.github/workflows/container.yml` valida o build em pull requests e
pushes. Publica a imagem `ghcr.io/<owner>/<repo>` em pushes na branch padrão
e em tags iniciadas por `v` (por exemplo, `v1.0.0`). Também permite execução
manual nessas referências.

A branch padrão recebe a tag `latest`; cada publicação também recebe uma tag
`sha-<commit>`. Tags Git preservam seu nome na imagem, como `v1.0.0`.

A autenticação usa o `GITHUB_TOKEN` automático com `packages: write`; não é
necessário cadastrar um token pessoal. Após a primeira publicação, a imagem
aparece em **Packages** no GitHub. Para permitir pulls anônimos, configure a
visibilidade do pacote como pública.

```bash
docker run --rm -p 8080:80 ghcr.io/<owner>/<repo>:latest
```

Substitua `<owner>/<repo>` pelo caminho do repositório em letras minúsculas.
