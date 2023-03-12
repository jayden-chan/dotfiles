return {
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
}
