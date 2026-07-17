#!/usr/bin/env python3
"""
choose_venv.py – interactive TUI to select a Python virtual environment.

Pre-defined environments are listed in VENVS.  The user navigates the list
with the arrow keys and confirms their choice with Enter.  The chosen
environment path is printed to stdout after the TUI exits so it can be
captured by a shell script, e.g.:

    VENV=$(python choose_venv.py)
    source "$VENV/bin/activate"
"""

from __future__ import annotations

import os
import sys
from pathlib import Path
from typing import ClassVar

from textual import on
from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.widgets import Label, ListItem, ListView, Static
from textual.containers import Container

# ---------------------------------------------------------------------------
# Pre-defined virtual environments
# ---------------------------------------------------------------------------
VENVS: list[dict] = [
    {
        "name": "stratus-aws",
        "path": "~/IdeaProjects/stratus-aws/.venv/bin/activate",
        "description": "Stratus utilities and CLI tools",
    },
    {
        "name": "denali-digital-backend",
        "path": "~/IdeaProjects/denali-digital-backend/.venv/bin/activate",
        "description": "Denali backend",
    },
    {
        "name": "(PUSH) denali-digital-backend",
        "path": "~/IdeaProjects/denali-digital-backend.amplify-push/.venv/bin/activate",
        "description": "Denali backend used only for Amplify push.",
    },
]


# ---------------------------------------------------------------------------
# TUI
# ---------------------------------------------------------------------------

class VenvItem(ListItem):
    """A single row in the venv list."""

    def __init__(self, name: str, path: str, description: str) -> None:
        super().__init__()
        self.venv_name = name
        self.venv_path = path
        self.venv_description = description

    def compose(self) -> ComposeResult:
        yield Label(f"[bold]{self.venv_name}[/bold]  [dim]{self.venv_path}[/dim]")
        yield Label(f"  {self.venv_description}", classes="description")


class VenvChooserApp(App):
    """Text-based UI for choosing a Python virtual environment."""

    CSS = """
    Screen {
        background: $surface;
        height: auto;
        padding: 0 0;
        margin: 0 0;
    }

    #outer {
        max-width: 120;
        height: auto;
        padding: 0 0;
        margin: 0 0;
   }

    ListView {
        height: auto;
        border: round $primary;
        margin: 0 0;
        padding: 0 1;
    }

    ListItem {
        padding: 0 0;
        height: auto;
    }

    ListItem:hover {
        background: $boost;
    }

    ListItem.--highlight {
        background: $accent 30%;
    }

    Label.description {
        color: $text-muted;
    }

    #status {
        height: 1;
        margin: 0 0;
        padding: 0 1;
        color: $text-muted;
    }
    """
    INLINE_PADDING = 0
    BINDINGS: ClassVar[list[Binding]] = [
        Binding("escape,q", "quit_cancel", "Quit", show=False),
    ]

    def __init__(self, venvs: list[dict]) -> None:
        super().__init__()
        self._venvs = venvs
        self.chosen: str | None = None

    def compose(self) -> ComposeResult:
        with Container(id="outer"):
            yield ListView(
                *[VenvItem(v["name"], v["path"], v["description"]) for v in self._venvs],
                id="venv_list",
            )
            yield Static("↑/↓ to navigate  •  Enter to select  •  q/Esc to cancel", id="status")

    def on_mount(self) -> None:
        self.title = "Choose a Python Virtual Environment"
        self.query_one(ListView).focus()

    @on(ListView.Selected)
    def _on_selected(self, event: ListView.Selected) -> None:
        if isinstance(event.item, VenvItem):
            self.chosen = str(Path(event.item.venv_path).expanduser())
            self.exit()

    def action_quit_cancel(self) -> None:
        self.chosen = None
        self.exit()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    app = VenvChooserApp(VENVS)
    app.run(inline=True)
    if app.chosen:
        # Print ONLY the path so callers can capture it cleanly.
        print(os.path.expanduser(app.chosen))
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()

