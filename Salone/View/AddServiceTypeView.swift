
import SwiftUI

struct AddServiceTypeView : View {
    @Environment(\.managedObjectContext) var managedObject
    @Environment(\.dismiss) var dismiss
    
    
    @State private var name=""
    @State private var price: Float = 0.0
    @State private var id=""
    
    
    
    var body: some View {
        Form{
            Section{
                HStack{
                    Text("Add a new service")
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {Image(systemName: "arrow.backward")}).onTapGesture {
                        dismiss();
                    }
                }
              
                TextField("Name",text: $name);
                TextField("Id",text: $id);
                TextField("Price", value: $price, formatter: doubleFormatter)
                    .keyboardType(.decimalPad);
                
            }
            HStack{
                Spacer()
                Button(
                    "Save"){
                        ServiceTypeController().addServiceType(id:id, name: name, price: price,context: managedObject);
                        dismiss();
                    }
                Spacer()
                
            }
        }
    }
    let intFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
    let doubleFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
              return formatter
         }()
    
    

}
