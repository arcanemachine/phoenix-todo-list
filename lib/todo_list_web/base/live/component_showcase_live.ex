defmodule TodoListWeb.ComponentShowcaseLive do
  use TodoListWeb, :live_view

  @form_data_types %{
    text: :string,
    email: :string,
    password: :string,
    checkbox: :boolean,
    select: :string,
    textarea: :string
  }
  defmodule FormData do
    defstruct text: "",
              email: "",
              password: "",
              checkbox: false,
              select: "",
              textarea: ""
  end

  defmodule TableRow do
    defstruct id: 0, col1: "Value 1", col2: "Value 2"
  end

  def form_data_changeset(%FormData{} = form_data, attrs \\ %{}) do
    {form_data, @form_data_types} |> Ecto.Changeset.cast(attrs, Map.keys(@form_data_types))
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Component Showcase",
       changeset: form_data_changeset(%FormData{}),
       table_rows: [
         %TableRow{id: 1, col1: "Value 1", col2: "Value 2"},
         %TableRow{id: 2, col1: "Value 3", col2: "Value 4"},
         %TableRow{id: 3, col1: "Value 5", col2: "Value 6"}
       ]
     )}
  end

  def render(assigns) do
    ~H"""
    <h2 class="text-3xl mb-4 text-center">Button</h2>

    <section class="text-center">
      <div>
        <.button class="w-32 btn-primary">
          Primary
        </.button>
        <.button class="w-32 ml-2 btn-secondary">
          Secondary
        </.button>
        <.button class="w-32 ml-2 btn-accent">
          Accent
        </.button>
        <.button class="w-32 ml-2 btn-neutral">
          Neutral
        </.button>
      </div>
      <div class="mt-4">
        <.button class="w-32 btn-info">
          Info
        </.button>
        <.button class="w-32 ml-2 btn-success">
          Success
        </.button>
        <.button class="w-32 ml-2 btn-warning">
          Warning
        </.button>
        <.button class="w-32 ml-2 btn-error">
          Error
        </.button>
      </div>
    </section>

    <h2 class="mt-16 mb-4 text-3xl text-center">Modal</h2>

    <.modal id="showcase-modal" on_confirm={hide_modal("showcase-modal")}>
      <:title>Modal Title</:title>
      <:subtitle>Modal Subtitle</:subtitle>
      <div class="my-8">
        Modal content
      </div>
      <:confirm>OK</:confirm>
      <:cancel>Cancel</:cancel>
    </.modal>

    <section class="text-center">
      <.button phx-click={show_modal("showcase-modal")}>
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

    <section class="text-center" phx->
      <.button phx-click={show("#showcase-flash-info")}>
        Show Info Flash
      </.button>
      <.button class="ml-4" phx-click={show("#showcase-flash-error")}>
        Show Error Flash
      </.button>
    </section>

    <h2 class="mt-16 text-3xl text-center">Simple Form</h2>

    <.simple_form :let={f} class="max-w-lg mx-auto" for={@changeset} phx-change="validate">
      <!-- fields -->
      <.input field={{f, :text}} label="Text Input" />
      <.input field={{f, :email}} label="Email Input" />
      <.input field={{f, :password}} type="password" label="Password Input" />

      <div class="form-control">
        <.input
          type="checkbox"
          field={{f, :checkbox}}
          class="checkbox checkbox-primary"
          label="Checkbox Input"
        />
      </div>

      <div class="form-control">
        <.input
          field={{f, :select}}
          type="select"
          options={[
            [key: "Select an option", value: "", disabled: true],
            [key: "First", value: "first"],
            [key: "Second", value: "second"],
            [key: "Third", value: "third"]
          ]}
          label="Select Input"
        />
      </div>

      <div class="form-control">
        <.label for="form_data_textarea">
          Textarea Label
        </.label>
        <.input
          type="textarea"
          field={{f, :textarea}}
          checked={true}
          class="checkbox checkbox-primary"
        />
      </div>
      <!-- actions -->
      <:actions>
        <.form_button_cancel />
        <.form_button>Form Button</.form_button>
        <.form_button_submit />
      </:actions>
    </.simple_form>

    <h2 class="mt-16 mb-4 text-3xl text-center">Header</h2>

    <.header class="bg-info/30 p-4 rounded-lg">
      Header Title
      <:subtitle>
        Header subtitle
      </:subtitle>
      <:actions>
        <.button class="w-28 btn-primary">OK</.button>
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

    <.button phx-click={show("#showcase-show-hide")}>Show</.button>
    <.button phx-click={hide("#showcase-show-hide")}>Hide</.button>

    <p>
      <!-- prevent page jumping when element visibility toggled -->
      <span id="showcase-show-hide">Now you see me...</span>
      <span>&nbsp;</span>
    </p>
    """
  end

  def handle_event("validate", %{"form_data" => form_data}, socket) do
    changeset =
      {%FormData{}, @form_data_types}
      |> Ecto.Changeset.cast(form_data, Map.keys(@form_data_types))
      |> Ecto.Changeset.add_error(:checkbox, "Error message")
      |> Ecto.Changeset.add_error(:select, "Error message")
      |> Ecto.Changeset.add_error(:textarea, "Error message")
      # |> Ecto.Changeset.validate_change(:text, fn :text, _value -> [text: "Error message"] end)
      |> Ecto.Changeset.validate_required(Map.keys(@form_data_types))

    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end
end
