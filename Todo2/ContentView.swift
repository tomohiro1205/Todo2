import SwiftUI

struct ContentView: View {
    @State var currentTodos: [Todo] = []
    @State var input = ""
    @AppStorage("todos") var todosData: Data = Data() //

    var body: some View {
        VStack(spacing: 0){
            HStack {
                TextField("Todo", text: $input)
                    .padding()
                    .background(.white)
                    .cornerRadius(5)
                Button("Enter") {
                    do {
                        try saveTodo(todo: input)
                        currentTodos = try getTodos()
                        input = ""
                    }catch {
                        print(error.localizedDescription)
                    } //do
                } //button
                .buttonStyle(.bordered)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
            } //HStack
            .padding()
            .background(.yellow)

            Spacer()
            List(currentTodos, id: \.id) { todo in
                Text(todo.value)
            } // list
            Spacer()
        } //VStack
        .onAppear{
            do {
                currentTodos = try getTodos()
            } catch {
                print(error.localizedDescription)
            }//do
        } //appear
    } // body
    func saveTodo(todo: String) throws{
        let todo = Todo(id: UUID(), value: todo)
        currentTodos.append(todo)
        let encodedTodos = try JSONEncoder().encode(currentTodos)
        //tryは失敗したときの保険のコードでthrowsとセット
        todosData = encodedTodos
    } //func
    
    func getTodos() throws ->[Todo] { //fetchだとまずいのでgetに変更した
        try JSONDecoder().decode([Todo].self, from: todosData)
    } //func
}// content view

#Preview {
    ContentView()
}
