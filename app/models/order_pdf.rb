class OrderPdf < Prawn::Document
  def initialize(purchases, title, view)
    super(top_margin: 70)
    @purchases = purchases
    @title = title
    @date = Time.now.localtime.strftime("%d %B, %Y")
    @view = view
    print_title
    print_purchases
    print_totals
  end
  
  def print_title
    text "#{@title}: #{@date}", size: 30, style: :bold
  end
  
  def print_purchases
    move_down 20
    table purchase_rows do
      row(0).font_style = :bold
      columns(1..6).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def purchase_rows
    [["Buyer", "Producer", "Product", "Qty", "Unit Price", "Full Price", "Paid"]] +
    @purchases.map do |purchase|
      [purchase.user.name, purchase.item.inventory.display_name, purchase.item.name, purchase.quantity, price(purchase.unit_price), price(purchase.full_price)]
    end
  end
  
  def price(num)
    @view.number_to_currency(num)
  end
  
  def print_totals
    move_down 15
    text "Total Payment: #{price(Purchase.total_payment)}", size: 16, style: :bold
  end
end