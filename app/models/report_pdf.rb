class ReportPdf < Prawn::Document

	def initialize(report_view, purchases, title, view)
		super(top_margin: 70)
		@purchases = purchases
		@title = title
		@date = Time.now.localtime.strftime("%d %B, %Y")
		@view = view
		@markup = 0.025
		print_title
		print_report(purchases, report_view)
	end

	def print_title
		text "#{@title}: #{@date}", size: 20, style: :bold
	end

	def print_report(purchases, report_view)
	    move_down 20
	    if report_view == "Producer"
	    	rows = producer_rows(purchases)
	    else
	    	rows = buyer_rows(purchases)
	    end
	    table rows do
	      row(0).font_style = :bold
	      columns(1..6).align = :right
	      self.row_colors = ["eaedee", "FFFFFF"]
	      self.header = true
	    end
	end

	def producer_rows(purchases)	
		[["Producer", "Order Total", "Handling Fee", "Payment"]] + 
      	purchases.keys.map do |producer|
      		[producer.display_name, producer.total_payment.round(2).to_s(), (producer.total_payment * @markup).round(2).to_s(), (producer.total_payment * (1 - @markup)).round(2).to_s()]
      	end
	end

	def buyer_rows(purchases)
		[["Buyer", "Order Total", "Handling Fee", "Payment"]] + 
      	purchases.map do |buyer|
      		[buyer.name, buyer.total_payment.round(2).to_s(), (buyer.total_payment * @markup).round(2).to_s(), (buyer.total_payment * (1 + @markup)).round(2).to_s()]
      	end
	end



end
