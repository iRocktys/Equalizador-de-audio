# Equalizador-de-audio

O código é um exemplo de um equalizador implementado no MATLAB. Ele permite a equalização de áudio em diferentes estilos musicais, como pop, rock, jazz, hip hop e eletrônica, além de oferecer opções para equalização personalizada, adicionar e remover eco e adicionar e remover distorção. O resultado final obtido dependerá das escolhas feitas durante a execução do programa. Cada opção selecionada no menu do equalizador aplicará um conjunto de ganhos específicos nas diferentes bandas de frequência do áudio de entrada.

## Técnicas utilizadas

Foi utilizado o filtro IIR como um filtro passa-banda. Um filtro passa-banda permite a passagem de frequências dentro de uma determinada faixa, enquanto atenua as frequências fora dessa faixa. Dividindo o áudio em varias faixas, podemos aplicar um ganho em cada frequência separadamente, conforme necessário.
