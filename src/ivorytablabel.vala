using Gtk;

[GtkTemplate(ui="/xyz/wiedenhoeft/ivory/ui/tab.ui")]
public class Ivory.TabLabel : Box {
	
	[GtkChild]
	public Image favicon;
	[GtkChild]
	public Label label;
	[GtkChild]
	public Button close_button;
	[GtkChild]
	public Spinner spinner;
	public Tab tab;

	public TabLabel(Tab tab) {
		this.tab = tab;
		tab.notify.connect(on_tab_notify);
		tab.load_changed.connect(on_tab_load_changed);
	}

	public void on_tab_notify(ParamSpec pspec) {
		switch(pspec.name) {
		case "title":
			label.set_label(tab.title);
			break;
		case "favicon":
			update_favicon();
			break;
		}
	}

	public void update_favicon() {
		var surface = (Cairo.ImageSurface) tab.favicon;
		if(surface != null) {
			var pixbuf = Gdk.pixbuf_get_from_surface(surface, 0, 0, surface.get_width(), surface.get_height());
			double height = 16, width = (height / pixbuf.height) * pixbuf.width;
			favicon.pixbuf = pixbuf.scale_simple((int) width, (int) height, Gdk.InterpType.BILINEAR);
		} else {
			favicon.set_from_icon_name("gtk-missing-image", IconSize.SMALL_TOOLBAR);
		}
	}

	public void on_tab_load_changed(WebKit.LoadEvent load_event) {
		switch(load_event) {
		case WebKit.LoadEvent.STARTED:
			favicon.hide();
			spinner.show();
			break;
		case WebKit.LoadEvent.FINISHED:
			spinner.hide();
			favicon.show();
			break;
		}
	}
}

