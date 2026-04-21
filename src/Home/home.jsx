import style from './home.module.css'
import image from './../assets/Muslim girl animation.jpg'
function Home  () {
  return (
    <div className={style.container}>
    <div className={style.home}>
    <img src={image} alt="" />
    <h3>Jessica Randal1</h3>
    <h4>London,United Kingdom</h4>
    <p>"Front-end developer and evid reader."</p>
    <div className={style.links}>
      <a href="https://github.com" target='_blank'  rel="noopener noreferrer">GitHub</a>
      <a href="https://www.frontendmentor.io" target='_blank'  rel="noopener noreferrer">Frontend mentor</a>
      <a href="https://www.linkedin.com" target='_blank'  rel="noopener noreferrer">Linkdin</a>
      <a href="https://twitter.com" target='_blank'  rel="noopener noreferrer">Twitter</a>
      <a href="https://instagram.com" target='_blank'  rel="noopener noreferrer">Instagram</a>
    </div>
     </div >
    </div>
  )
}

export default Home;