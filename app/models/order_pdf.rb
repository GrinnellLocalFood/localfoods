class OrderPdf < Prawn::Document
  def initialize(order_view, purchases, title, view)
    super(top_margin: 70)
    if(order_view.nil?)
    @purchases = purchases
    @title = title
    @date = Time.now.localtime.strftime("%d %B, %Y")
    @view = view
    print_title
    print_purchases
    print_totals
  else
     buyer_or_producer(purchases,title,view)
  end
  end

  def buyer_or_producer(purchases, title, view)
    @purchases_by_user = purchases
    @title = title
    @date = Time.now.localtime.strftime("%d %B, %Y")
    @view = view
    print_title
    for user in @purchases_by_user.keys
      print_entity_title(user)
      @purchases = @purchases_by_user[user]
      print_purchases(user)
      print_totals(user)
    end
  end

  def print_entity_title(entity)
    move_down 10
    if entity.class == Inventory
      text "#{entity.display_name}", size: 20, style: :bold
    else
      text "#{entity.name}", size: 20, style: :bold
    end
  end
  
  def print_title
    text "#{@title}: #{@date}", size: 30, style: :bold
  end
  
  def print_purchases(entity = nil)
    move_down 20
    table purchase_rows(entity) do
      row(0).font_style = :bold
      columns(1..6).align = :right
      self.row_colors = ["eaedee", "FFFFFF"]
      self.header = true
    end
  end

  def purchase_rows(entity = nil)
    if entity.nil?
      [["Buyer", "Producer", "Product", "Qty", "Unit Price", "Full Price", "Paid"]] +
      @purchases.map do |purchase|
        [purchase.user.name, purchase.item.inventory.display_name, purchase.item.name, purchase.quantity, price(purchase.unit_price), price(purchase.full_price), purchase.paid ? "Yes" : "No" ]
      end
    elsif entity.class == Inventory
      [["Buyer", "Product", "Qty", "Unit Price", "Full Price", "Paid"]] +
      @purchases.map do |purchase|
        [purchase.user.name, purchase.item.name, purchase.quantity, price(purchase.unit_price), price(purchase.full_price), purchase.paid ? "Yes" : "No" ]
      end
    else
       [["Producer", "Product", "Qty", "Unit Price", "Full Price", "Paid"]] +
      @purchases.map do |purchase|
        [purchase.item.inventory.display_name, purchase.item.name, purchase.quantity, price(purchase.unit_price), price(purchase.full_price), purchase.paid ? "Yes" : "No" ]
    end
    end
  end
  
  def price(num)
    @view.number_to_currency(num)
  end
  
  def print_totals(entity = nil)
    move_down 15
    if entity.nil?
      text "Total Payment: #{price(Purchase.total_payment)}", size: 16, style: :bold
    else
      text "Total Payment: #{price(entity.total_payment)}", size: 16, style: :bold
    end
  end

end