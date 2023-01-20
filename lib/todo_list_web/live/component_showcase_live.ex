defmodule TodoListWeb.ComponentShowcaseLive do
  use TodoListWeb, :live_view

  defmodule TableRow do
    defstruct id: 0, col1: "Value 1", col2: "Value 2"
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Component Showcase",
       # data
       table_rows: [
         %TableRow{id: 1, col1: "Value 1", col2: "Value 2"},
         %TableRow{id: 2, col1: "Value 3", col2: "Value 4"},
         %TableRow{id: 3, col1: "Value 5", col2: "Value 6"}
       ]
     )}
  end

  def render(assigns) do
    ~H"""
    <h2 class="text-3xl mb-4 text-center">Modal</h2>

    <.modal id="showcase-modal" show={true} on_confirm={hide_modal("showcase-modal")}>
      <:title>Modal Title</:title>
      <div class="my-8">
        Modal content
      </div>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <section class="text-center">
      <.button class="btn btn-primary" phx-click={show_modal("showcase-modal")}>
        Show Modal
      </.button>
    </section>

    <h2 class="mt-16 mb-4 text-3xl text-center">Flash</h2>

    <.flash id="showcase-flash-info" kind={:info} autoshow={false} title="Info flash title">
      Info flash message
    </.flash>
    <.flash id="showcase-flash-error" kind={:error} autoshow={false} title="Error flash title">
      Error flash message
    </.flash>

    <section class="text-center">
      <.button class="btn btn-primary" phx-click={show("#showcase-flash-info")}>
        Show Info Flash
      </.button>
      <.button class="ml-4 btn btn-primary" phx-click={show("#showcase-flash-error")}>
        Show Error Flash
      </.button>
    </section>

    <h2 class="mt-16 text-3xl text-center">Simple Form</h2>

    <.simple_form :let={f} for={:nothing}>
      <!-- fields -->
      <.input field={{f, :text}} label="Text Input" />
      <.input field={{f, :email}} label="Email Input" />
      <.input field={{f, :password}} type="password" label="Password Input" required />

      <div class="form-control">
        <.input
          type="checkbox"
          field={{f, :checkbox}}
          checked={true}
          class="checkbox checkbox-primary"
          label="Checkbox Input"
        />
      </div>

      <div class="form-control">
        <.input
          field={{f, :select}}
          type="select"
          options={["First", "Second", "Third"]}
          label="Select Input"
        />
      </div>

      <div class="form-control">
        <.input
          type="textarea"
          field={{f, :textarea}}
          checked={true}
          class="checkbox checkbox-primary"
          label="Textarea Input"
        />
      </div>
      <!-- actions -->
      <:actions>
        <.button class="btn btn-primary">Submit</.button>
        <input type="reset" value="Reset" class="btn btn-secondary min-w-[7rem]" />
      </:actions>
    </.simple_form>

    <h2 class="mt-16 mb-4 text-3xl text-center">Error/Label</h2>

    <.label>Label</.label>
    <.error>Error message</.error>

    <h2 class="mt-16 mb-4 text-3xl text-center">Header</h2>

    <.header class="bg-secondary/40 p-4 rounded-lg">
      Header Title
      <:subtitle>
        Header subtitle
      </:subtitle>
      <:actions>
        <.button class="btn btn-primary">OK</.button>
      </:actions>
    </.header>

    <h2 class="mt-16 mb-4 text-3xl text-center">Table</h2>

    <.table id="showcase-table" rows={@table_rows}>
      <:col :let={row} label="Column 1"><%= row.col1 %></:col>
      <:col :let={row} label="Column 2"><%= row.col2 %></:col>
    </.table>

    <h2 class="mt-16 mb-4 text-3xl text-center">List</h2>
    <h4 class="text-md mb-4 text-center">Renders a data list.</h4>

    <.list>
      <:item title="Item 1">Value 1</:item>
      <:item title="Item 2">Value 2</:item>
      <:item title="Item 3">Value 3</:item>
    </.list>

    <h2 class="mt-16 mb-4 text-3xl text-center">Back</h2>
    <h4 class="text-md mb-4 text-center">Renders a back navigation link.</h4>

    <.back navigate={~p"/"}>
      Back
    </.back>

    <h2 class="mt-16 mb-4 text-3xl text-center">Show/Hide</h2>

    <.button class="btn btn-primary" phx-click={show("#showcase-show-hide")}>Show</.button>
    <.button class="btn btn-primary" phx-click={hide("#showcase-show-hide")}>Hide</.button>

    <p id="showcase-show-hide">
      <!-- prevent page jumping when element visibility toggled -->
      <span>&nbsp;</span>
      Now you see me...
    </p>
    """
  end
end
