# LeaseReviewer

A lease counsel for Brazilian rental contracts. Reviews a contract clause
by clause before you sign it, answers questions about it afterwards,
computes the annual IGP-M or IPCA readjustment, and drafts the notice to
the tenant. Paired with a small scheduled runner that emails the landlord
two months before every readjustment and renewal.

**Status: private build.** The full agent, its legal knowledge base, and
the runner live in a private repository because they sit next to real
contracts. This page shows the idea and the shape. Nothing here is legal
advice.

## What it does

Four modes, picked from what you hand it:

| Mode | You give | You get |
|---|---|---|
| **Review** | A contract, draft or signed | A memo: key terms, findings ordered by severity with the article each rests on, missing clauses a landlord wants, and a "change before signing" list |
| **Consult** | A question about a contract in context | An answer that cites the clause and the law, and says when it depends on a fact it does not have |
| **Readjust** | Index, base month, current rent | The twelve monthly values, the accumulated factor, the new rent. Never only the result |
| **Notify** | A contract and a readjustment or renewal | A formal letter in Portuguese, addressed to the tenant, presented as a draft for you to send |

It knows both the landlord's and the tenant's positions and argues for
the landlord by default. One line in the prompt flips that.

## Shape

```
agent/            portable Markdown: system prompt + knowledge by topic
runner/           Python on launchd: check dates, fetch index, compute, draft, email
registry/         one YAML per contract, extracted by the agent, checked by a human
```

The knowledge base is the Lei do Inquilinato and the relevant Código
Civil articles split by topic under 20 KB each, a file of settled
jurisprudence, the mechanics of IGP-M and IPCA publication, and a
catalogue of clauses that hurt one side or the other.

The runner never talks to a tenant. It fetches index values from the
Banco Central's public API, does the arithmetic in Python, asks the agent
for the letter, and emails the landlord. Sending the letter is a human
act.

## Example

The user pastes a draft residential contract and asks for a review. The
agent answers in Portuguese. Abridged:

> **Leitura:** minuta ainda não assinada. Análise orientada à proteção do locador.
>
> **Ficha.** Locação residencial, 30 meses, aluguel R$ 3.200,00, reajuste anual pelo IGP-M, garantia por fiança, aviso de desocupação não previsto.
>
> **Achados, por gravidade.**
>
> 1. **Cláusula 7 — reajuste.** Diz "reajuste anual pelo IGP-M" sem fixar o mês-base nem a janela de doze meses. Na prática cada parte calcula um valor diferente e a discussão chega ao reajuste seguinte. Expõe o locador. Redação sugerida: "reajustado a cada doze meses pela variação acumulada do IGP-M/FGV dos doze meses anteriores ao mês de aniversário, aplicando-se a partir dele; sendo negativa a variação, o aluguel permanece inalterado."
> 2. **Cláusula 12 — benfeitorias.** Omite a renúncia à indenização e à retenção por benfeitorias úteis. Sem ela o locatário pode reter o imóvel ao final (Lei 8.245/91, art. 35). Incluir a renúncia expressa.
> 3. **Ausente — vistoria.** Não há laudo de vistoria anexo nem cláusula que o exija. Sem laudo, cobrar danos na devolução é quase inviável.
>
> **Antes de assinar:** reescrever a cláusula 7, incluir renúncia a benfeitorias, anexar laudo de vistoria, fixar aviso de desocupação de 30 dias.
>
> *Esta análise não substitui parecer de advogado habilitado.*

Follow-up, "e se o IGP-M acumulado for negativo?", gets the two readings
of a silent clause, the recommendation to keep the rent unchanged, and the
wording that removes the ambiguity next time.

## Why it is built this way

- **One agent, full table.** A language model compounding twelve values by
  hand is where a wrong rent comes from. The prompt requires the whole
  table in every readjustment answer so an error is visible, and the
  scheduled path does the math in Python anyway.
- **Knowledge under 20 KB per file.** The law alone is 60 KB. Files past
  the limit get read whole or not at all, and "not at all" is what happens.
- **Nothing automatic reaches a tenant.** A wrong notice sent on schedule
  is worse than no notice.
- **Errors email you too.** A scheduled job that fails silently looks like a
  month with nothing due. Every failure produces a message.

## Licence

MIT, same as the repo. The showcase text is free to reuse. The private
build is not published.
