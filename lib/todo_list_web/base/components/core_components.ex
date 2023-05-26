defmodule TodoListWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com), using the
  [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir) project.
  """
  use Phoenix.Component, global_prefixes: ~w(x-)

  alias Phoenix.LiveView.JS
  import TodoListWeb.Gettext

  @doc """
  Renders a list of links.

  ## Example

      <.action_links items={[
        %{content: "Return to your profile", navigate: ~p"/users/profile", class: "list-back"}
      ]} />
  """
  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :items, :list, required: true

  def action_links(assigns) do
    ~H"""
    <section class={["mt-12", @class]}>
      <h3 class="text-2xl font-bold">
        <%= @title || "Actions" %>
      </h3>
      <ul class="mt-2 ml-6">
        <li :for={item <- @items} class={[["mt-2 pl-2 list-dash"], [Map.get(item, :class, "")]]}>
          <.link
            href={Map.get(item, :href, false)}
            navigate={Map.get(item, :navigate, false)}
            patch={Map.get(item, :patch, false)}
            method={Map.get(item, :method, "get")}
            data-confirm={Map.get(item, :confirm, false)}
          >
            <%= item.content %>
          </.link>
        </li>
      </ul>
    </section>
    """
  end

  @doc """
  Renders a loading indicator.

  ## Example

      <.loader />
  """
  attr :class, :string, default: nil

  def loader(assigns) do
    ~H"""
    <Heroicons.arrow_path class={[
      "w-5 h-5 hidden phx-click-loading:inline phx-submit-loading:inline animate-spin",
      @class
    ]} />
    """
  end

  @doc """
  Renders a page footer.

  ## Example

      <.footer />
  """
  def footer(assigns) do
    ~H"""
    <div class="w-full">
      <% # limit max width of navbar by nesting it inside a full-width element %>
      <section class="max-w-[100rem] mx-auto bg-base-200 py-6 text-center 2xl:rounded-t-xl">
        <ul class="list-none">
          <li>
            <div class="text-xl font-bold">
              Todo List
            </div>
          </li>

          <% # project-related links %>
          <li class="mt-6">
            <.link href="/">
              Home
            </.link>
          </li>
          <li class="mt-2">
            <.link href="/users/profile">
              Your Account
            </.link>
          </li>

          <% # generic links %>
          <li class="mt-6">
            <.link href="/terms-of-use">
              Terms of Use
            </.link>
          </li>
          <li class="mt-2">
            <.link href="/privacy-policy">
              Privacy Policy
            </.link>
          </li>
          <li class="mt-2">
            <.link href="/contact-us">
              Contact Us
            </.link>
          </li>

          <% # legal stuff %>
          <li class="mt-6">
            <small>
              &copy; Copyright <%= DateTime.utc_now().year %>
              <br />This project is licensed under <a href="https://github.com/aws/mit-0">MIT-0</a>.
            </small>
          </li>

          <% # github logo %>
          <li class="my-6 w-100">
            <a href="https://github.com/arcanemachine/phoenix-todo-list">
              <svg
                class="inline"
                width="40"
                height="40"
                viewBox="0 0 1024 1024"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                alt="GitHub Logo"
                title="GitHub Logo"
              >
                <path
                  class="fill-slate-600"
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M8 0C3.58 0 0 3.58 0 8C0 11.54 2.29 14.53 5.47 15.59C5.87 15.66 6.02 15.42
                      6.02 15.21C6.02 15.02 6.01 14.39 6.01 13.72C4 14.09 3.48 13.23 3.32 12.78C3.23
                      12.55 2.84 11.84 2.5 11.65C2.22 11.5 1.82 11.13 2.49 11.12C3.12 11.11 3.57 11.7
                      3.72 11.94C4.44 13.15 5.59 12.81 6.05 12.6C6.12 12.08 6.33 11.73 6.56 11.53C4.78
                      11.33 2.92 10.64 2.92 7.58C2.92 6.71 3.23 5.99 3.74 5.43C3.66 5.23 3.38 4.41
                      3.82 3.31C3.82 3.31 4.49 3.1 6.02 4.13C6.66 3.95 7.34 3.86 8.02 3.86C8.7 3.86
                      9.38 3.95 10.02 4.13C11.55 3.09 12.22 3.31 12.22 3.31C12.66 4.41 12.38 5.23 12.3
                      5.43C12.81 5.99 13.12 6.7 13.12 7.58C13.12 10.65 11.25 11.33 9.47 11.53C9.76
                      11.78 10.01 12.26 10.01 13.01C10.01 14.08 10 14.94 10 15.21C10 15.42 10.15 15.67
                      10.55 15.59C13.71 14.53 16 11.53 16 8C16 3.58 12.42 0 8 0Z"
                  transform="scale(64)"
                >
                </path>
              </svg>
            </a>
          </li>
        </ul>
      </section>
    </div>
    """
  end

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        Are you sure?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>

  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:

      <.modal id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/posts")}>
        Are you sure you?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  slot :inner_block, required: true
  slot :title
  slot :subtitle
  slot :confirm
  slot :cancel

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      class="relative z-50 hidden"
    >
      <div
        id={"#{@id}-bg"}
        class="fixed inset-0 bg-base-100/90 transition-opacity"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-2 sm:p-4 lg:py-4">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={hide_modal(@on_cancel, @id)}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id)}
              class={[
                "hidden max-w-[30rem] mx-auto relative rounded-2xl bg-base-100 p-8",
                "shadow-lg shadow-base-700/10 ring-1 ring-zinc-300/10 transition"
              ]}
            >
              <% # close button %>
              <div class="absolute top-5 right-4">
                <button
                  phx-click={hide_modal(@on_cancel, @id)}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <Heroicons.x_mark solid class="h-5 w-5 stroke-current" />
                </button>
              </div>

              <div id={"#{@id}-content"}>
                <header :if={@title != []}>
                  <h1
                    id={"#{@id}-title"}
                    class="text-2xl font-semibold leading-8 text-base-800 text-center"
                  >
                    <% # title %>
                    <%= render_slot(@title) %>
                  </h1>
                  <p
                    :if={@subtitle != []}
                    id={"#{@id}-description"}
                    class="mt-2 text-lg leading-6 text-base-600 text-center"
                  >
                    <% # subtitle %>
                    <%= render_slot(@subtitle) %>
                  </p>
                </header>

                <section class="text-center">
                  <%= render_slot(@inner_block) %>
                </section>
                <div :if={@confirm != [] or @cancel != []} class="mt-8 text-center">
                  <.link
                    :for={cancel <- @cancel}
                    phx-click={hide_modal(@on_cancel, @id)}
                    class="w-[7rem] mx-2 btn btn-secondary"
                  >
                    <%= render_slot(cancel) %>
                  </.link>
                  <.button
                    :for={confirm <- @confirm}
                    class="w-[7rem] mx-2"
                    id={"#{@id}-confirm"}
                    phx-click={@on_confirm}
                    phx-disable-with
                  >
                    <%= render_slot(confirm) %>
                  </.button>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders the primary navbar.

  ## Example

      <.navbar>
        <ul>
          <li>
            <.link navigate={~p"/users/profile"}>Your profile</.link>
          </li>
        </ul>
      </.navbar>
  """
  slot :user_action_menu_items, required: true

  def navbar(assigns) do
    ~H"""
    <div class="w-full">
      <% # limit max width of navbar by nesting it inside a full-width element %>
      <nav
        data-component="page-navbar"
        class="navbar max-w-[100rem] mx-auto bg-base-200 py-0 2xl:rounded-b-xl"
      >
        <% # navbar start items %>
        <div class="flex-1">
          <% # navbar title %>
          <.link href="/" aria-label="Todo List" class="flex-0 btn-ghost btn px-2">
            <div class="font-title inline-flex text-2xl normal-case text-accent">
              Todo List
            </div>
          </.link>
        </div>
        <% # navbar end items %>
        <div class="mr-1 flex-none">
          <% # user actions %>
          <div
            class="dropdown-end dropdown"
            id="navbar-dropdown-user-actions"
            x-data="{ show: false }"
            x-title="navbarUserActionMenu"
            x-bind:class="show && 'dropdown-open'"
            x-on:pointerdown.outside="show = false"
          >
            <button
              class="btn-ghost btn-square btn m-1"
              x-tooltip="User Actions"
              x-on:focus="show = true"
              x-on:blur="show = false"
              x-on:click="show = true"
              x-on:click.outside="show = false"
            >
              <Heroicons.user_circle solid class="h-7 w-7 stroke-current" />
            </button>
            <ul class="mt-1 dropdown-content menu rounded-box w-52 bg-base-100 p-2 shadow">
              <div class="mt-2 mb-3 text-center text-lg font-bold text-underline">User Actions</div>
              <%= render_slot(@user_action_menu_items) %>
            </ul>
          </div>
          <% # settings %>
          <.navbar_settings_menu />
        </div>
      </nav>
    </div>
    """
  end

  @doc """
  Renders a settings menu in the navbar.

  ## Example

      <.navbar_settings_menu />
  """

  def navbar_settings_menu(assigns) do
    ~H"""
    <div x-data="{ show: false }" x-title="navbarSettingsMenu">
      <button class="btn-ghost btn-square btn m-1" x-on:click="show = true" x-tooltip="Settings">
        <Heroicons.cog_6_tooth solid class="h-7 w-7 stroke-current" />
      </button>
      <div class="modal" x-bind:class="show && 'modal-open'">
        <div
          class="relative max-w-xs modal-box border-2 overflow-hidden"
          x-show="show"
          x-trap.inert.noscroll="show"
          x-on:click.outside="show = false"
          x-transition.duration.500ms
        >
          <h2 class="mb-12 text-3xl font-bold text-center">Settings</h2>

          <div class="flex justify-between align-center h-12 w-full max-w-xs my-4 ml-1">
            <div class="my-auto text-lg font-semibold">
              Dark Mode
            </div>
            <div x-data="darkModeSelect">
              <select class="select select-bordered" x-model="choice" x-on:change="handleChange">
                <option>Auto</option>
                <option>Light</option>
                <option>Dark</option>
              </select>
            </div>
          </div>

          <div class="form-control mt-12 w-full max-w-xs">
            <button class="btn btn-secondary" x-on:click="show = false">Close</button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :autoshow, :boolean, default: true, doc: "whether to auto show the flash on mount"
  attr :close, :boolean, default: true, doc: "whether the flash can be closed"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-mounted={@autoshow && show("##{@id}")}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      x-on:click="$store.liveSocket.execJS($el, $el.getAttribute('phx-click'))"
      role="alert"
      class={[
        "fixed hidden top-2 left-0 right-0 mx-auto w-80 sm:w-96 z-50 rounded-lg p-3 shadow-md shadow-base-900/5 ring-1 transition-opacity duration-500",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 p-3 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="mt-[1px] px-4 text-sm font-semibold text-center">
        <%!--
          <Heroicons.information_circle :if={@kind == :info} mini class="inline h-4 w-4" />
          <Heroicons.exclamation_circle :if={@kind == :error} mini class="inline h-4 w-4" />
          <span><%= @title %></span>
        --%>
        <%= msg %>
      </p>
      <button
        :if={@close}
        type="button"
        class="group absolute top-1 right-0 p-2"
        aria-label={gettext("close")}
      >
        <Heroicons.x_mark solid class="h-5 w-5 stroke-current opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form :let={f} for={%{}} as={:user} phx-change="validate" phx-submit="save">
        <.input field={{f, :email}} label="Email"/>
        <.input field={{f, :username}} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, default: nil, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"
  attr :class, :any, default: nil

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  attr :confirmation_required, :boolean, default: false
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} class={["w-full max-w-sm mx-auto", @class]} {@rest}>
      <div data-confirmation-required={@confirmation_required} x-data="$store.components.simpleForm">
        <%= render_slot(@inner_block, f) %>

        <%= if @confirmation_required do %>
          <label>
            <.header class="bg-info/30 mb-6 p-4 rounded-lg">
              <span class="font-normal text-sm">
                I have confirmed that the data above is accurate.
              </span>
              <:actions>
                <input
                  type="checkbox"
                  class="py-4 align-middle checkbox checkbox-lg bg-base-100"
                  name="confirm-checkbox"
                  x-model="confirmed"
                  required
                />
              </:actions>
            </.header>
          </label>
        <% end %>

        <div
          class="mt-4"
          x-bind:class={@confirmation_required && "!confirmed && 'disabled-button-wrapper'"}
        >
          <div :for={action <- @actions} class="flex items-center justify-center gap-4">
            <%= render_slot(action, f) %>
          </div>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :any, default: nil
  attr :loader, :boolean, default: false
  attr :rest, :global, default: %{loader: false}

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "btn",
        @class
      ]}
      {@rest}
    >
      <%= if @loader do %>
        <span class="phx-click-loading:hidden phx-submit-loading:hidden">
          <%= render_slot(@inner_block) %>
        </span>
        <.loader />
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={{f, :email}} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any
  attr :name, :any
  attr :label, :string, default: nil
  attr :class, :string, default: nil

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :value, :any
  attr :field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :email}"
  attr :errors, :list
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :debounce, :integer, default: 500, doc: "how long to debounce before emitting an event"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :rest, :global, include: ~w(autocomplete cols disabled form max maxlength min minlength
                                   pattern placeholder readonly required rows size step)
  slot :inner_block

  def input(%{field: {f, field}} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn ->
      name = Phoenix.HTML.Form.input_name(f, field)
      if assigns.multiple, do: name <> "[]", else: name
    end)
    |> assign_new(:id, fn -> Phoenix.HTML.Form.input_id(f, field) end)
    |> assign_new(:value, fn -> Phoenix.HTML.Form.input_value(f, field) end)
    |> assign_new(:errors, fn -> translate_errors(f.errors || [], field) end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns = assign_new(assigns, :checked, fn -> input_equals?(assigns.value, "true") end)

    ~H"""
    <label
      phx-feedback-for={@name}
      class="flex items-center gap-4 text-base-600"
      data-component="input"
    >
      <input type="hidden" name={@name} value="false" />
      <input
        type="checkbox"
        id={@id || @name}
        name={@name}
        value="true"
        checked={@checked}
        class={["checkbox", @class]}
        phx-debounce={@debounce}
        {@rest}
      />
      <%= @label %>
    </label>
    <div class="flex min-h-[2.5rem] show-empty-element">
      <.error :for={msg <- @errors}>
        <%= msg %>
      </.error>
    </div>
    """
  end

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} data-component="input">
      <input
        type="hidden"
        name={@name}
        id={@id || @name}
        class={["hidden", @class]}
        value={@value}
        {@rest}
      />
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} data-component="input">
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class={[
          "mt-1 block w-full py-2 px-3 border border-gray-300 bg-white sm:text-sm",
          "rounded-md shadow-sm focus:outline-none focus:ring-zinc-500 focus:border-base-500"
        ]}
        multiple={@multiple}
        phx-debounce={@debounce}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <div class="flex min-h-[2.5rem] show-empty-element">
        <.error :for={msg <- @errors}>
          <%= msg %>
        </.error>
      </div>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class="mb-12" phx-feedback-for={@name} data-component="input">
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id || @name}
        name={@name}
        class={[
          input_border(@errors),
          "mt-2 block min-h-[6rem] w-full rounded-lg border-base-300 py-[7px] px-[11px]",
          "text-base-900 focus:border-base-400 focus:outline-none focus:ring-4",
          "focus:ring-zinc-500/5 sm:text-sm sm:leading-6 phx-no-feedback:border-base-300",
          "phx-no-feedback:focus:border-base-400 phx-no-feedback:focus:ring-zinc-500/5"
        ]}
        phx-debounce={@debounce}
        {@rest}
      ><%= @value %></textarea>
      <div class="flex min-h-[2.5rem] show-empty-element">
        <.error :for={msg <- @errors}>
          <%= msg %>
        </.error>
      </div>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} data-component="input">
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id || @name}
        value={@value}
        class={[
          input_border(@errors),
          "mt-2 block w-full rounded-lg border-base-300 py-[7px] px-[11px] text-base-900",
          "focus:outline-none focus:ring-4 sm:text-sm sm:leading-6 phx-no-feedback:border-base-300",
          "phx-no-feedback:focus:border-base-400 phx-no-feedback:focus:ring-zinc-500/5"
        ]}
        phx-debounce={@debounce}
        {@rest}
      />
      <div class="flex min-h-[2.5rem] show-empty-element">
        <.error :for={msg <- @errors}>
          <%= msg %>
        </.error>
      </div>
    </div>
    """
  end

  defp input_border([] = _errors),
    do: "border-base-300 focus:border-base-400 focus:ring-zinc-500/5"

  defp input_border([_ | _] = _errors),
    do: "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-base-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <div
      class="phx-no-feedback:hidden flex mt-1 gap-2 font-bold leading-6 text-xs text-rose-500"
      data-component="error"
    >
      <Heroicons.exclamation_circle mini class="mt-0.5 h-5 w-5 flex-none fill-rose-500" />
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  # FORM HELPERS #
  @doc """
  Renders a form button.

  ## Examples

      <.form_button>Button Text</.form_button>
      <.form_button phx-click="go" class="ml-2">Button Text</.form_button>
  """
  attr :type, :string, default: "button"
  attr :class, :any, default: nil
  attr :content, :string, default: ""
  attr :loader, :boolean, default: false
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the form button"

  slot :inner_block

  def form_button(assigns) do
    ~H"""
    <.button
      type={@type}
      class={[
        "form-button",
        @class
      ]}
      loader={@loader}
      {@rest}
    >
      <%= if @content != "" do %>
        <%= @content %>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </.button>
    """
  end

  @doc """
  Renders a form submit button.

  ## Examples

      <.form_submit_button />Send!</.form_submit_button>
      <.form_submit_button phx-click="go" class="ml-2">Custom submit text</.form_submit_button>
  """
  attr :type, :string, default: "submit"
  attr :class, :any, default: nil
  attr :content, :string, default: "Submit"
  attr :loader, :boolean, default: true
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the form button"

  def form_button_submit(assigns) do
    ~H"""
    <.form_button
      type={@type}
      class={["btn-success", @class]}
      content={@content}
      loader={@loader}
      {@rest}
    />
    """
  end

  @doc """
  Renders a form cancel button.

  ## Examples

      <.form_submit_button />Send!</.form_submit_button>
      <.form_submit_button phx-click="go" class="ml-2">Custom submit text</.form_submit_button>
  """
  attr :type, :string, default: "button"
  attr :class, :any, default: nil
  attr :url, :string, default: nil, doc: "the URL to redirect to"
  attr :content, :string, default: "Cancel"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the form button"

  def form_button_cancel(assigns) do
    ~H"""
    <a href={@url} tabindex="-1">
      <.form_button
        type={@type}
        class={["btn-secondary", @class]}
        onclick={@url || "history.back()"}
        content={@content}
        {@rest}
      />
    </a>
    """
  end

  @doc """
  Renders an alert indicating that the form has errors.
  """
  def form_error_alert(assigns) do
    ~H"""
    <div class="alert alert-error shadow-xl" role="alert">
      To continue, fix the errors in the form.
    </div>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-4", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :row_click, :any, default: nil
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    ~H"""
    <div id={@id} class="overflow-y-auto">
      <table class="w-full max-w-max mt-10 mx-auto">
        <thead class="text-center text-[0.8125rem] leading-6 text-base-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
          </tr>
        </thead>
        <tbody class="relative divide-y divide-base-100 border-t border-base-200 text-sm leading-6 text-base-700">
          <tr
            :for={row <- @rows}
            id={"#{@id}-#{Phoenix.Param.to_param(row)}"}
            class="relative group hover:bg-white"
          >
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["px-2", @row_click && "hover:cursor-pointer"]}
            >
              <div :if={i == 0}>
                <span class="absolute h-full w-4 top-0 -left-4 group-hover:bg-base-50 sm:rounded-l-xl" />
                <span class="absolute h-full w-4 top-0 -right-4 group-hover:bg-base-50 sm:rounded-r-xl" />
              </div>
              <div class="block py-4 pr-6">
                <span class={["relative", i == 0 && "font-semibold text-base-900"]}>
                  <%= render_slot(col, row) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="p-0 w-14">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span
                  :for={action <- @action}
                  class="relative ml-4 px-2 font-semibold leading-6 text-base-900 hover:text-base-700"
                >
                  <%= render_slot(action, row) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-base-100">
        <div :for={item <- @item} class="flex gap-4 py-4 sm:gap-8">
          <dt class="w-1/4 flex-none text-[0.8125rem] leading-6 text-base-500"><%= item.title %></dt>
          <dd class="text-sm leading-6 text-base-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-base-900 hover:text-base-700"
      >
        <Heroicons.arrow_left solid class="w-3 h-3 stroke-current inline" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-500",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def show_with_delay(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-1000 delay-1000",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(TodoListWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(TodoListWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  defp input_equals?(val1, val2) do
    Phoenix.HTML.html_escape(val1) == Phoenix.HTML.html_escape(val2)
  end
end
