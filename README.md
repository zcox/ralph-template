Minimal template for starting a new project built by Ralph and Claude Code. 

Based on and inspired by:
- https://github.com/ghuntley/how-to-ralph-wiggum
- https://ghuntley.com/solana/
- https://www.youtube.com/watch?v=4Nna09dG_c0

![](./ralph_factory.png)

```sh
mkdir your-project
cd your-project

curl -L https://github.com/zcox/ralph-template/archive/HEAD.tar.gz | tar xz --strip-components=1

echo "describe your idea in raw notes" >> ideas/1.md

claude
> /specs ideas/1.md
```
