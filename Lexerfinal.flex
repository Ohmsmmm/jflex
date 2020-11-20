//  usercode
%%
%class Lexer 
%public
%standalone
%unicode
%int
%line
%column
%{
	int symTableSize = 0;
	String[]symTable = new String[10000];
	boolean isAlreadyExist(String name)
	{
		for(int i = 0; i < symTableSize; ++i)
		{
			if(symTable[i].equals(name))
			{
				return true;
			}
		}
		return false;
	}
%}
//   optional & declaration
	LineTerminator = \r|\n|\r\n
	WhiteSpace = {LineTerminator}|[\t\f]|\s
	TraditionalComment  = (\/\*)(.|({LineTerminator}))*(\*\/)
	EndOfLineComment = \/\/.*
	Comment = {TraditionalComment}|{EndOfLineComment}
	Identifier = [a-zA-Z][a-zA-Z0-9]*
	DecIntegerLiteral = 0|([1-9][0-9]*)
	IntegerMixed = (\d+[^ \d]{1}[^ \t|\f|\r|\n|\r\n]*)|(\w+\d*[\+\-\*\/][^ \t\f\r\n\r\n]*)
	symbols = ((\<\=)|(\>\=)|(\=\=)|(\+\+)|(\-\-)|\>|\<|\+|\-|\*|\/)
	string = (\")(.)*(\") 
%%
// lexical rules
<YYINITIAL>
{
    ({DecIntegerLiteral}{Identifier})|([^ \t\f\r\n\r\n\w]+{Identifier})
    {
          System.out.printf("ERROR at Line %d Column %d\n", yyline + 1, yycolumn + 1);
          System.exit(0);
      }
	{Comment}
	{
		//DO NOTHING
	}
	{symbols}
	{
		System.out.println("operator : "+yytext());
	}
	";"|"("|")"
	{
		if(yytext().equals(";"))
			System.out.println("SEMICOLON : "+";");
		else 
			System.out.println("PARENTHESES : "+yytext());
	}
	"if"|"then"|"else"|"endif"|"while"|"do"|"endwhile"|"print"|"newline"|"read"
	{
		System.out.println("KEYWORDS : "+yytext());
	}
	{Identifier}
	{
		if(isAlreadyExist(yytext()))
		{
			System.out.printf("identifier \"%s\" already in symbol table\n",yytext());
		}
		else
		{
			symTable[symTableSize++] = yytext();
			System.out.println("new identifier : "+yytext());
		}
	}	
	{DecIntegerLiteral}
	{
		System.out.println("INTEGER : "+yytext());
	}
	{string}
	{
		System.out.println("STRING : "+yytext().substring(1,yytext().length() - 1));
	}
	
	{WhiteSpace}
	{

	}
    .
    {
          System.out.printf("ERROR at Line %d Column %d\n", yyline + 1, yycolumn + 1);
          System.exit(0);
      }
}