package Servlets;

public class Product {
    private int id;
    private String nom;
    private String description;
    private double prix;
    private String image;
    private int stock;
    private int categorieId;

    public Product(int id, String nom, String description, double prix, String image, int stock, int categorieId) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.image = image;
        this.stock = stock;
        this.categorieId = categorieId;
    }

    public int getId() { return id; }
    public String getNom() { return nom; }
    public String getDescription() { return description; }
    public double getPrix() { return prix; }
    public String getImage() { return image; }
    public int getStock() { return stock; }
    public int getCategorieId() { return categorieId; }

	public void setId(int id) {
		this.id = id;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setPrix(double prix) {
		this.prix = prix;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public void setCategorieId(int categorieId) {
		this.categorieId = categorieId;
	}
}
