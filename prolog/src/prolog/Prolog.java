/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package prolog;

import java.util.LinkedList;
import java.util.Random;
import javax.swing.JOptionPane;
import org.jpl7.*;
import static prolog.Ventana.q1;

/**
 *
 * @author bryam
 */
public class Prolog {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        
        String entradaUsuario = JOptionPane.showInputDialog("TAMAÑO DE LA MATRIZ\n"
                + "Ej: 7 es tabla 7X7");
        int xy=java.lang.Integer.parseInt(entradaUsuario);
        new Ventana(xy,xy).setVisible(true);
        
        
    }
    static LinkedList<java.lang.Integer[]> crearBase(int x, int y){
        int puntosAPoner=(x*y)*30/100;
        int min = 0;
        int max = x*y-1;
        Random random = new Random();
        
        LinkedList<java.lang.Integer> randoms=new LinkedList<>();
        
        for(int i=0; i<puntosAPoner; i++){
            
            while (true){
                int value = random.nextInt(max + min) + min;
                
                if(randoms.contains(value)){
                    continue;
                }
                randoms.add(value);
                break;
            }
        }
        
        LinkedList<java.lang.Integer[]> casillas=new LinkedList<>();
        
        System.out.println("\nPUNTOS: "+puntosAPoner);
        int cont=0;
        for(int i=0; i<x; i++){
            for(int j=0; j<x; j++){
                
                if(randoms.contains(cont)){
                    java.lang.Integer[] casilla={i, j, 1};
                    System.out.println("["+casilla[0]+", "+casilla[1]+", "+casilla[2]+"]");
                    casillas.add(casilla);
                }
                else{
                    java.lang.Integer[] casilla={i, j, 0};
                    System.out.println("["+casilla[0]+", "+casilla[1]+", "+casilla[2]+"]");
                    casillas.add(casilla);
                }
                cont++;
            }
         
        }
        System.out.println("\nSE CREA LA BASE:\n");
        int contador=0;
        
        while (contador<x*y){
            java.lang.Integer[] casilla=casillas.get(contador);
            if(casilla[0]==x-1 && casilla[1]==y-1){
                break;
            }else if(casilla[0]==x-1){
                java.lang.Integer[] casilla2=casillas.get(contador+1);
                String hecho="assert(conectado(casilla("+casilla[0]+", "+casilla[1]+", "+casilla[2]+
                        "), casilla("+casilla2[0]+", "+casilla2[1]+", "+casilla2[2]+")))";
                System.out.println(hecho+".");
                Query q3=new Query(hecho);
                q3.oneSolution();
            }else if(casilla[1]==y-1){
                java.lang.Integer[] casilla2=casillas.get(contador+x);
                String hecho="assert(conectado(casilla("+casilla[0]+", "+casilla[1]+", "+casilla[2]+
                        "), casilla("+casilla2[0]+", "+casilla2[1]+", "+casilla2[2]+")))";
                System.out.println(hecho+".");
                Query q3=new Query(hecho+".");
                q3.oneSolution();
            }else{
                java.lang.Integer[] casilla2=casillas.get(contador+x);
                java.lang.Integer[] casilla3=casillas.get(contador+1);
                String hecho1="assert(conectado(casilla("+casilla[0]+", "+casilla[1]+", "+casilla[2]+
                        "), casilla("+casilla2[0]+", "+casilla2[1]+", "+casilla2[2]+")))";
                System.out.println(hecho1+".");
                String hecho2="assert(conectado(casilla("+casilla[0]+", "+casilla[1]+", "+casilla[2]+
                        "), casilla("+casilla3[0]+", "+casilla3[1]+", "+casilla3[2]+")))";
                System.out.println(hecho2+".");
                Query q3=new Query(hecho1);
                q3.oneSolution();
                Query q4=new Query(hecho2);
                q4.oneSolution();
            }
            contador++;
        }
        return casillas;
    }
   
    
}
