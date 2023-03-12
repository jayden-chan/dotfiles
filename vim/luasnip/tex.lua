return {
	s("fr", fmt("\\frac{{{1}}}{{{2}}}", { i(1), i(0) })),
	s("b", fmt("\\textbf{{{1}}}", i(0))),
	s("i", fmt("\\textit{{{1}}}", i(0))),
	s("rm", fmt("\\text{{{1}}}", i(0))),
	s("tt", fmt("\\texttt{{{1}}}", i(0))),
	s("ml", fmt("${1}$", i(0))),
	s("vs", fmt("\\vspace{{{1}}}", i(0))),
	s("code", fmt("\\inputminted[baselinestretch=1,linenos]{{{1}}}{{{2}}}", { i(1), i(0) })),
	s(
		"start",
		fmt(
			[[
% vim: textwidth=89 colorcolumn=90
\documentclass[11pt]{{article}}
\usepackage{{amsmath}}
\usepackage{{amssymb}}
\usepackage{{enumerate}}
\usepackage{{fancyhdr}}
\usepackage{{fontspec}}
\usepackage{{graphicx}}
\usepackage{{hyperref}}
\usepackage{{mathrsfs}}
\usepackage{{mathtools}}
\usepackage{{minted}}
\usepackage{{siunitx}}
\usepackage{{systeme}}
\usepackage{{tabularx}}

\usepackage[vlined,ruled]{{algorithm2e}}
\usepackage[table]{{xcolor}}

\usepackage[
	margin=1in,
	includefoot,
	footskip=30pt,
]{{geometry}}
\usepackage{{layout}}

\hypersetup{{
	colorlinks=true,
	linkcolor=blue,
	filecolor=magenta,
	urlcolor=cyan,
	citecolor=black,
}}

% for FreeSerif the font size should probably be set to 12pt in the \documentclass
% call above
\setmainfont{{FreeSerif}}
\setmonofont{{JetBrainsMono Nerd Font Mono}}[
	Scale=MatchLowercase
]

% Bibliography
% (\printbibliography to print at the end)
%\usepackage[
%	backend=biber,
%	style=ieee,
%	%style=mla,
%	sorting=ynt
%]{{biblatex}}
%\addbibresource{{bibliography.bib}}

\title{{{1}}}
\author{{Jayden Chan (V00898517)}}
\date{{{2}}}

\begin{{document}}
\maketitle
{3}
\end{{document}}
]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		"beg",
		fmt(
			[[
\begin{{{1}}}
{2}
\end{{{1}}}
]],
			{ i(1), i(0) },
			{ repeat_duplicates = true }
		)
	),
	s(
		"fl",
		fmt(
			[[
\begin{{flalign*}}
{1}
\end{{flalign*}}
]],
			{ i(0) }
		)
	),
	s(
		"en",
		fmt(
			[[
\begin{{enumerate}}
	\item
		{1}
\end{{enumerate}}
]],
			{ i(0) }
		)
	),
	s(
		"it",
		fmt(
			[[
\begin{{itemize}}
	\item
		{1}
\end{{itemize}}
]],
			{ i(0) }
		)
	),
	s(
		"tab",
		fmt(
			[[
\begin{{center}}
	\begin{{tabularx}}{{\textwidth}}{{ {1} }}
		\hline
		{2}
	\end{{tabularx}}
\end{{center}}
]],
			{ i(1), i(0) }
		)
	),
	s(
		"fig",
		fmt(
			[[
\begin{{figure}}[H]
	\begin{{center}}
		\caption{{{1}}}
		\includegraphics[width=1.0\textwidth]{{{2}}}
	\end{{center}}
\end{{figure}}
]],
			{ i(1), i(0) }
		)
	),
	s(
		"amat",
		fmt(
			[[
\begin{{amatrix}}{{{1}}}
{2}
\end{{amatrix}}
]],
			{ i(1), i(0) }
		)
	),
	s(
		"ma",
		fmt(
			[[
\[
	{1}
\]
]],
			{ i(0) }
		)
	),
}
