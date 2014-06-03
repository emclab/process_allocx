JobshopQuotex.quote_task_class = 'EventTaskx::EventTask'
JobshopQuotex.mfg_process_class = 'MfgProcessx::MfgProcess'
JobshopQuotex.rfq_class = 'JobshopRfqx::Rfq'  #for engine mfg_processx
JobshopQuotex.new_order_path = "mfg_orderx.new_order_path(:quote_id => @quote.id, :parent_record_id => @quote.id, :parent_resource =>'jobshop_quotex/quotes')"
JobshopQuotex.order_resource = 'mfg_orderx/orders'
JobshopQuotex.customer_class = 'Kustomerx::Customer'
